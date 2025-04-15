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

// MARK: Domain Mapping

extension UserResponse {
    
    func toParticipant() -> Participant {
        return Participant(
            id: id,
            userName: name,
            displayName: displayName,
            profileImage: ProfileImage(
                imageURL: profileImageURL
            ),
            createdAt: createdAt
        )
    }
}
