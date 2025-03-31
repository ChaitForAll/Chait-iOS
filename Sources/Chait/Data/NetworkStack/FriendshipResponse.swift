//
//  FriendshipResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
    
struct FriendResponse: Decodable {
    let friendshipID: UUID
    let userID: UUID
    let friendID: UUID
    let created_at: Date
}
