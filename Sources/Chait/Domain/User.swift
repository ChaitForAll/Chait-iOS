//
//  User.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

enum UserError: Error {
    case invalidImage
}

final class User: Identifiable {
    let id: UUID
    let userName: String
    var displayName: String
    var profileImage: URL
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: UUID,
        userName: String,
        displayName: String,
        profileImage: URL,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.userName = userName
        self.displayName = displayName
        self.profileImage = profileImage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: Function(s)
    
    func changeDisplayName(_ newDisplayName: String) {
        self.displayName = newDisplayName
    }
}
