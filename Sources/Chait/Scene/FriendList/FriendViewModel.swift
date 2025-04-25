//
//  FriendViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit

final class FriendViewModel: Identifiable {
    
    var image: UIImage?
    
    let id: UUID
    let name: String
    let displayName: String
    let createdAt: Date
    let imageURL: URL
    
    init(friend: Friend) {
        self.id = friend.friendID
        self.name = friend.name
        self.displayName = friend.displayName.isEmpty ? friend.name : friend.displayName
        self.createdAt = friend.createdAt
        self.imageURL = friend.image
    }
}
