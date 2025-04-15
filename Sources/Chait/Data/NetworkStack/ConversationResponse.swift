//
//  ConversationResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation

enum ConversationTypeResponse: String, Decodable {
    case `private`
    case group
}

struct ConversationResponse: Decodable {
    let id: UUID
    let title: String
    let conversationType: ConversationTypeResponse
    let createdAt: Date
    let updatedAt: Date
}

extension ConversationResponse {
    func toPrivateConversation(participants: Set<Participant>) -> PrivateConversation {
        return PrivateConversation(
            title: title,
            updatedAt: updatedAt,
            lastMessageSentAt: .now, /* TODO: Add Actual Capability */
            id: id,
            createdAt: createdAt,
            participants: participants
        )
    }
    
    func toGroupConversation(participants: Set<Participant>) -> GroupConversation {
        return GroupConversation(
            title: title,
            updatedAt: updatedAt,
            lastMessageSentAt: .now, /* TODO: Add Actual Capability */
            participants: participants,
            id: id,
            createdAt: createdAt,
            owner: participants.first! /* TODO: Add Actual Capability */
        )
    }
}
