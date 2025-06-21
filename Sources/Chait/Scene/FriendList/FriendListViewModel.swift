//
//  FriendListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine
import UIKit

final class FriendListViewModel {
    
    // MARK: Property(s)
    
    @Published var friendIdentifiers: [UUID] = []
    
    private var allFriends: [UUID: Friend] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    private let fetchFriendsListUseCase: FetchFriendsListUseCase
    private let userImageService: UserImageService
    
    init(
        fetchFriendsListUseCase: FetchFriendsListUseCase,
        userImageService: UserImageService
    ) {
        self.fetchFriendsListUseCase = fetchFriendsListUseCase
        self.userImageService = userImageService
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        fetchFriendsList()
    }
    
    func friendViewModel(for id: UUID) -> FriendViewModel? {
        guard let friend = allFriends[id] else {
            return nil
        }
        return FriendViewModel(profileImageDataService: self.userImageService, friend: friend)
    }
    
    // MARK: Private Function(s)
    
    private func fetchFriendsList() {
        fetchFriendsListUseCase.fetchFriendList()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] friends in
                    for friend in friends {
                        self?.allFriends[friend.friendID] = friend
                    }
                    self?.friendIdentifiers.append(contentsOf: friends.map(\.friendID))
                }
            )
            .store(in: &cancelBag)
    }
}
