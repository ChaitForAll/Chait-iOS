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
    let participants: Set<Participant>
    
    init(
        title: String,
        updatedAt: Date,
        lastMessageSentAt: Date,
        id: UUID,
        createdAt: Date,
        participants: Set<Participant>
    ) {
        self.title = title
        self.updatedAt = updatedAt
        self.lastMessageSentAt = lastMessageSentAt
        self.id = id
        self.createdAt = createdAt
        self.participants = participants
    }
    
    // MARK: Function(s)
    
    func defaultTitle() -> String {
        let participantNames = participants.map { $0.displayName }.joined(separator: ",")
        return title.isEmpty ? participantNames : title
    }
}
