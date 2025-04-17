//
//  ConversationMembershipResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
    
struct ConversationMembershipResponse: Decodable {
    let id: UUID
    let userID: UUID
    let conversationID: UUID
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case conversationID = "conversationId"
        case createdAt
    }
}

