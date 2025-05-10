//
//  FetchFriendsListUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum FetchFriendsListError: Error {
    case unknown
}

protocol FetchFriendsListUseCase {
    func fetchFriendList() -> AnyPublisher<[Friend], FetchFriendsListError>
}

final class DefaultFetchFriendsListUseCase: FetchFriendsListUseCase {
    
    private let friendRepository: FriendRepository
    
    init(repository: FriendRepository) {
        self.friendRepository = repository
    }
    
    func fetchFriendList() -> AnyPublisher<[Friend], FetchFriendsListError> {
        friendRepository.fetchFriendList()
    }
}
