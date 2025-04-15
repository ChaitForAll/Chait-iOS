//
//  ConversationRemoteDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Combine
import Supabase

protocol ConversationRemoteDataSource {
    func fetchConversation(_ conversationIdentifiers: [UUID]) async throws -> [ConversationResponse]
}
