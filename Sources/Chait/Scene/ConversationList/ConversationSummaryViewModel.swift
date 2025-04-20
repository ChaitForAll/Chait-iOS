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
    
    init(_ conversationSummary: ConversationSummary) {
        self.id = UUID()
        self.conversationID = conversationSummary.id
        self.title = conversationSummary.title
    }
}
