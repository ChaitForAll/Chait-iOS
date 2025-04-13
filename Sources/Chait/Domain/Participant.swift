//
//  Participant.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

final class Participant: User {
    
    // MARK: Property(s)
    
    var displayName: String
    
    let id: UUID
    let userName: String
    let createdAt: Date
    let profileImage: ProfileImage?
    
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

extension Participant: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Participant, rhs: Participant) -> Bool {
        return lhs.id == rhs.id
    }
}
