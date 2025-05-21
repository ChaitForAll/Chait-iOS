//
//  ConversationSummary.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

struct ConversationSummary: Identifiable {
    let id: UUID
    let title: String
    let titleImage: String?
    var lastMessage: Message?
    
    init(_ conversationResponse: ConversationResponse) {
        self.id = conversationResponse.id
        self.title = conversationResponse.title
        self.titleImage = nil
        self.lastMessage = nil
    }
}
