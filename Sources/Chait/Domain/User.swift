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
    
    // MARK: Property(s)
    
    let id: UUID
    let userName: String
    var displayName: String
    var profileImage: ProfileImage
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: UUID,
        userName: String,
        displayName: String,
        profileImage: ProfileImage,
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
        guard !newDisplayName.isEmpty, displayName != newDisplayName else {
            return
        }
        self.displayName = newDisplayName
    }
    
    func changeProfileImage(_ newProfileImage: URL) throws {
        let newProfileImage = ProfileImage(imageURL: newProfileImage)
        guard newProfileImage.isValid() else {
            throw UserError.invalidImage
        }
        self.profileImage = newProfileImage
    }
}
