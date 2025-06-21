//
//  UserImageResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

enum ImageTypeResponse: String, Decodable {
    case profile
    case cover
}

struct UserImageResponse: Decodable {
    let id: UUID
    let userID: UUID
    let imageURL: URL
    let imageType: ImageTypeResponse
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imageType = "image_type"
        case imageURL = "image_url"
    }
}
