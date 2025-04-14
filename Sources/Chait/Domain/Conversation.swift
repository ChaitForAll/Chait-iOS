//
//  Conversation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

enum ConversationType {
    case `private`
    case group
}

protocol Conversation: AnyObject, Identifiable {
    var id: UUID { get }
    var title: String { get set }
    var conversationType: ConversationType { get }
    var participants: Set<Participant> { get }
    var createdAt: Date { get }
    var updatedAt: Date { get set }
    var lastMessageSentAt: Date { get set }
    
    func defaultTitle() -> String
}

extension Conversation {
    func changeTitle(_ newTitle: String) {
        guard !title.isEmpty, title != newTitle else {
            return
        }
        self.title = newTitle
    }
    
    func isParticipant(_ userLookingFor: UUID) -> Bool {
        return participants.contains(where: { $0.id == userLookingFor })
    }
}
