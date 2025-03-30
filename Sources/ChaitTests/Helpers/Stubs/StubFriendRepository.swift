//
//  StubFriendRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation
import Combine

final class StubFriendRepository: FriendRepository {
    
    // MARK: Property(s)
    
    private var error: FetchFriendsListError?
    private var friends: [Friend]?
    
    // MARK: Function(s)
    
    func withFailure(_ error: FetchFriendsListError) -> Self {
        self.error = error
        return self
    }
    
    func withSuccess(_ friends: [Friend]) -> Self {
        self.friends = friends
        return self
    }
    
    func fetchFriendList(userID: UUID) -> AnyPublisher<[Friend], FetchFriendsListError> {
        guard var error else {
            return friends.publisher
                .compactMap { $0 }
                .setFailureType(to: FetchFriendsListError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
}
