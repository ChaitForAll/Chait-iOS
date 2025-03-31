//
//  FriendBuilder.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation

final class FriendBuilder {
    
    // MARK: Property(s)
    
    private var friendID: UUID?
    private var createdAt: Date?
    
    // MARK: Function(s)
    
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
            friendID: friendID ?? UUID(),
            createdAt: createdAt ?? Date.now
        )
    }
}
