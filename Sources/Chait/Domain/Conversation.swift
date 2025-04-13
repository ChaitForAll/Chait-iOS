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

protocol Conversation: Identifiable {
    var id: UUID { get }
    var title: String { get set }
    var conversationType: ConversationType { get }
    var createdAt: Date { get }
    var updatedAt: Date { get set }
    var lastMessageSentAt: Date { get set }
    
    func defaultTitle() -> String
}
