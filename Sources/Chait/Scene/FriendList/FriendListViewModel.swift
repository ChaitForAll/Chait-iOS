//
//  FriendListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

final class FriendListViewModel {
    
    // MARK: Type(s)
    
    struct Output {
        let fetchedFriendList: AnyPublisher<[UUID], Never>
    }
    
    // MARK: Property(s)
    
    private var cancelBag: Set<AnyCancellable> = .init()
    private var friendsList: [Friend] = []
    
    private let userID: UUID
    private let fetchFriendsListUseCase: FetchFriendsListUseCase
    private let fetchedFriendListSubject: PassthroughSubject<[UUID], Never> = .init()
    
    init(userID: UUID, fetchFriendsListUseCase: FetchFriendsListUseCase) {
        self.userID = userID
        self.fetchFriendsListUseCase = fetchFriendsListUseCase
    }
    
    // MARK: Function(s)
    
    func bind() -> Output {
        return Output(fetchedFriendList: fetchedFriendListSubject.eraseToAnyPublisher())
    }
    
    func onViewDidLoad() {
        fetchFriendsList()
    }
    
    // MARK: Private Function(s)
    
    private func fetchFriendsList() {
        fetchFriendsListUseCase
            .fetchFriendList(userID: userID)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] friendsList in
                    self?.friendsList.append(contentsOf: friendsList)
                    self?.fetchedFriendListSubject.send(friendsList.map { $0.friendID })
                }
            )
            .store(in: &cancelBag)
    }
}
