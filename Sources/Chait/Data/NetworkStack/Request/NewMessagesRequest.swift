//
//  NewMessagesRequest.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct NewMessageRequest: Encodable {
    let text: String
    let sender: UUID
    let conversationId: UUID
    
    enum CodingKeys: String, CodingKey {
        case text
        case sender
        case conversationId = "conversation_id"
    }
}
