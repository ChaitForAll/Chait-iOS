//
//  MessageResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct MessageResponse: Decodable {
    let text: String
    let messageID: UUID
    let senderID: UUID
    let channelID: UUID
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case text
        case messageID = "id"
        case senderID = "sender"
        case channelID = "channel_id"
        case createdAt = "created_at"
    }
}
