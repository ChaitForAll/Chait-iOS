//
//  GroupConversation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

enum GroupConversationError: Error {
    case participantNotFound
    case lastOneStanding
}

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
    
    func addParticipantFromContact(_ contactUser: ContactUser) {
        let newParticipant = Participant(
            id: contactUser.id,
            userName: contactUser.userName,
            displayName: contactUser.displayName,
            profileImage: contactUser.profileImage,
            createdAt: contactUser.createdAt
        )
        guard !participants.contains(newParticipant) else {
            return
        }
        participants.insert(newParticipant)
    }
    
    func transferOwnership(to nextOwner: Participant) throws {
        guard participants.contains(nextOwner) else {
            throw GroupConversationError.participantNotFound
        }
        self.owner = nextOwner
    }
    
    func removeParticipant(_ participant: Participant) {
        participants.remove(participant)
    }
}
