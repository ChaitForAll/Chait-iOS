//
//  FriendRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

protocol FriendRepository {
    func fetchFriendList(userID: UUID) -> AnyPublisher<[Friend], FetchFriendsListError>
}
