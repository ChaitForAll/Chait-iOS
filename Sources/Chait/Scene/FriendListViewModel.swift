//
//  FriendListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

final class FriendListViewModel {
    
    // MARK: Property(s)
    
    private let userID: UUID
    private let fetchFriendsListUseCase: FetchFriendsListUseCase
    
    init(userID: UUID, fetchFriendsListUseCase: FetchFriendsListUseCase) {
        self.userID = userID
        self.fetchFriendsListUseCase = fetchFriendsListUseCase
    }
}
