//
//  AppUser.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

final class AppUser: User {
    
    // MARK: Property(s)
    
    var displayName: String
    var profileImage: ProfileImage?
    
    let id: UUID
    let userName: String
    let createdAt: Date
    
    init(
        displayName: String,
        id: UUID,
        userName: String,
        createdAt: Date,
        profileImage: ProfileImage?
    ) {
        self.displayName = displayName
        self.id = id
        self.userName = userName
        self.createdAt = createdAt
        self.profileImage = profileImage
    }
    
    // MARK: Function(s)
    
    func changeProfileImage(_ newImageURL: URL) throws {
        let profileImage = ProfileImage(imageURL: newImageURL)
        guard profileImage.isValid() else {
            throw UserError.invalidImage
        }
        self.profileImage = profileImage
    }
}
