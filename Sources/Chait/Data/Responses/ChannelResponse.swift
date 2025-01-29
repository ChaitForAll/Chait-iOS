//
//  ChannelResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct ChannelResponse: Decodable {
    let id: UUID
    let title: String
    let createdAt: Date
    let updateAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case createdAt = "created_at"
        case updateAt = "updated_at"
    }
}
