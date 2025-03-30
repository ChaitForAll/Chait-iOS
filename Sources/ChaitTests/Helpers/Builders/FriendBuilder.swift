//
//  FriendBuilder.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation

final class FriendBuilder {
    
    // MARK: Property(s)
    
    private var friendshipIdentifier: UUID?
    private var userID: UUID?
    private var friendID: UUID?
    private var createdAt: Date?
    
    // MARK: Function(s)
    
    func withFriendshipIdentifier(_ friendshipIdentifier: UUID) -> Self {
        self.friendshipIdentifier = friendshipIdentifier
        return self
    }
    
    func withUserID(_ userID: UUID) -> Self {
        self.userID = userID
        return self
    }
    
    func withFriendID(_ friedID: UUID) -> Self {
        self.friendID = friedID
        return self
    }
    
    func withCreatedAt(_ createdAt: Date) -> Self {
        self.createdAt = createdAt
        return self
    }
    
    func build() -> Friend {
        return Friend(
            id: friendID ?? UUID() ,
            userID: userID ?? UUID(),
            friendID: friendID ?? UUID(),
            createdAt: createdAt ?? Date.now
        )
    }
}
