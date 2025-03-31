//
//  FriendListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

final class FriendListViewModel {
    
    // MARK: Property(s)
    
    private var cancelBag: Set<AnyCancellable> = .init()
    private var friendsList: [Friend] = []
    
    private let userID: UUID
    private let fetchFriendsListUseCase: FetchFriendsListUseCase
    
    init(userID: UUID, fetchFriendsListUseCase: FetchFriendsListUseCase) {
        self.userID = userID
        self.fetchFriendsListUseCase = fetchFriendsListUseCase
    }
    
    // MARK: Private Function(s)
    
    private func fetchFriendsList() {
        fetchFriendsListUseCase
            .fetchFriendList(userID: userID)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { friendsList in
                    self.friendsList.append(contentsOf: friendsList)
                }
            )
            .store(in: &cancelBag)
    }
}
