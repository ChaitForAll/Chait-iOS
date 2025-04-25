//
//  FriendListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine
import UIKit

final class FriendListViewModel {
    
    // MARK: Type(s)
    
    struct Output {
        let fetchedFriendList: AnyPublisher<[UUID], Never>
        let imageReady: AnyPublisher<[UUID], Never>
    }
    
    // MARK: Property(s)
    
    private var cancelBag: Set<AnyCancellable> = .init()
    private var friendsList: [FriendViewModel] = []
    
    private let userID: UUID
    private let fetchFriendsListUseCase: FetchFriendsListUseCase
    private let fetchedFriendListSubject: PassthroughSubject<[UUID], Never> = .init()
    private let imageReadySubject: PassthroughSubject<[UUID], Never> = .init()
    private let fetchImageUseCase: FetchImageUseCase
    
    init(userID: UUID, fetchFriendsListUseCase: FetchFriendsListUseCase, fetchImageUseCase: FetchImageUseCase) {
        self.userID = userID
        self.fetchFriendsListUseCase = fetchFriendsListUseCase
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    // MARK: Function(s)
    
    func bind() -> Output {
        return Output(
            fetchedFriendList: fetchedFriendListSubject.eraseToAnyPublisher(),
            imageReady: imageReadySubject.eraseToAnyPublisher()
        )
    }
    
    func onViewDidLoad() {
        fetchFriendsList()
    }
    
    func friend(for id: UUID) -> FriendViewModel? {
        return friendsList.first { $0.id == id }
    }
    
    // MARK: Private Function(s)
    
    private func fetchFriendsList() {
        fetchFriendsListUseCase
            .fetchFriendList(userID: userID)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] friendsList in
                    self?.friendsList.append(
                        contentsOf: friendsList.map { FriendViewModel(friend: $0) }
                    )
                    self?.fetchedFriendListSubject.send(friendsList.map { $0.friendID })
                }
            )
            .store(in: &cancelBag)
    }
    
    private func prepareImage(_ friendViewModel: FriendViewModel) -> AnyPublisher<UUID, Never> {
        fetchImageUseCase.fetchImage(url: friendViewModel.imageURL)
            .receive(on: DispatchQueue.main)
            .replaceError(with: UIImage.add)
            .flatMap { image in
                friendViewModel.image = image
                return Just(friendViewModel.id)
            }
            .eraseToAnyPublisher()
    }
}
