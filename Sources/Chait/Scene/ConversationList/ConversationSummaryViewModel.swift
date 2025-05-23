//
//  ConversationSummaryViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
    
struct ConversationSummaryViewModel: Identifiable {
    let id: UUID
    let conversationID: UUID
    let title: String
    let lastMessage: String
    let lastMessageSender: String
    
    init(_ conversationSummary: ConversationSummary) {
        self.id = UUID()
        self.conversationID = conversationSummary.id
        self.title = conversationSummary.title
        self.lastMessage = conversationSummary.lastMessageText ?? ""
        self.lastMessageSender = conversationSummary.lastMessageSenderName ?? ""
    }
}
