//
//  ConversationMessageViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct ConversationMessageViewModel: Identifiable {
    let id: UUID
    let text: String
    let senderID: UUID
    let createdAt: Date
    
    init(message: Message) {
        self.id = message.messageID
        self.text = message.text
        self.senderID = message.senderID
        self.createdAt = message.createdAt
    }
}
