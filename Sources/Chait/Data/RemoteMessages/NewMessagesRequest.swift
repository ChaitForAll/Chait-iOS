//
//  NewMessagesRequest.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct NewMessageRequest: Encodable {
    let text: String
    let senderID: UUID
    let channelID: UUID
    
    enum CodingKeys: String, CodingKey {
        case text
        case senderID = "sender"
        case channelID = "channel_id"
    }
}
