//
//  GroupConversation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

final class GroupConversation: Conversation {
    
    // MARK: Property(s)
    
    var title: String
    var updatedAt: Date
    var lastMessageSentAt: Date
    var participants: Set<Participant>
    var owner: Participant
    
    let id: UUID
    let createdAt: Date
    let conversationType: ConversationType = .group
    
    init(
        title: String,
        updatedAt: Date,
        lastMessageSentAt: Date,
        participants: Set<Participant>,
        id: UUID,
        createdAt: Date,
        owner: Participant
    ) {
        self.title = title
        self.updatedAt = updatedAt
        self.lastMessageSentAt = lastMessageSentAt
        self.participants = participants
        self.id = id
        self.createdAt = createdAt
        self.owner = owner
    }
    
    // MARK: Function(s)
    
    func defaultTitle() -> String {
        if title.isEmpty {
            guard participants.isEmpty else {
                return owner.userName + "'s Group Conversation"
            }
            return participants.map { $0.userName }.joined(separator: ",")
        }
        return title
    }
}
