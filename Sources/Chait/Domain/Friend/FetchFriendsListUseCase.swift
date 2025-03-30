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
    func fetchFriendList(userID: UUID) -> AnyPublisher<[Friend], FetchFriendsListError>
}
