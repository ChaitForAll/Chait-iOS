//
//  UserResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

struct UserResponse: Decodable {
    let id: UUID
    let name: String
    let displayName: String
    let createdAt: Date
    let profileImageURL: URL
}

