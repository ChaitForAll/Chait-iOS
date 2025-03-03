//
//  ChannelResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct ChannelResponse: Decodable {
    let title: String
    let channelID: UUID
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case channelID = "id"
        case createdAt = "created_at"
    }
}
