//
//  PrivateConversation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

final class PrivateConversation: Conversation {
    
    // MARK: Property(s)
    
    var title: String
    var updatedAt: Date
    var lastMessageSentAt: Date
    
    let id: UUID
    let createdAt: Date
    let otherParticipant: Participant
    let conversationType: ConversationType = .private
    
    init(
        title: String,
        updatedAt: Date,
        lastMessageSentAt: Date,
        id: UUID,
        createdAt: Date,
        otherParticipant: Participant
    ) {
        self.title = title
        self.updatedAt = updatedAt
        self.lastMessageSentAt = lastMessageSentAt
        self.id = id
        self.createdAt = createdAt
        self.otherParticipant = otherParticipant
    }
    
    // MARK: Function(s)
    
    func defaultTitle() -> String {
        return title.isEmpty ? otherParticipant.userName : title
    }
}
