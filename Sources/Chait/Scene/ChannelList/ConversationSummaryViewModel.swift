//
//  ConversationSummaryViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
    
struct ConversationSummaryViewModel: Identifiable {
    let id: UUID
    let channelID: UUID
    let title: String
    
    init(_ conversationSummary: ConversationSummary) {
        self.id = UUID()
        self.channelID = conversationSummary.id
        self.title = conversationSummary.title
    }
}
