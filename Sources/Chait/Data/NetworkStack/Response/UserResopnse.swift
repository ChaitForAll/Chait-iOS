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
    let status: String
    let createdAt: Date
    let profileImage: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case displayName
        case status
        case createdAt
        case profileImage = "profileImage"
    }
}

// MARK: Domain Mapping

extension UserResponse {
    
    func toParticipant() -> Participant {
        return Participant(
            id: id,
            userName: name,
            displayName: displayName,
            profileImage: ProfileImage(
                imageURL: profileImage
            ),
            createdAt: createdAt
        )
    }
}
