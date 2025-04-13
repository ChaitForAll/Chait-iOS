//
//  ContactUser.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

final class ContactUser: User {
    
    // MARK: Property(s)
    
    var displayName: String
    
    let id: UUID
    let userName: String
    let profileImage: ProfileImage?
    let createdAt: Date
    
    init(
        id: UUID,
        userName: String,
        displayName: String,
        profileImage: ProfileImage?,
        createdAt: Date
    ) {
        self.id = id
        self.userName = userName
        self.displayName = displayName
        self.profileImage = profileImage
        self.createdAt = createdAt
    }
}
