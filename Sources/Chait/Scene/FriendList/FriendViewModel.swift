//
//  FriendViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit

struct FriendViewModel: Identifiable {
    let id: UUID
    let name: String
    let displayName: String
    let createdAt: Date
    var image: UIImage?
    
    init(friend: Friend) {
        self.id = friend.friendID
        self.name = friend.name
        self.displayName = friend.displayName.isEmpty ? friend.name : friend.displayName
        self.createdAt = friend.createdAt
    }
}
