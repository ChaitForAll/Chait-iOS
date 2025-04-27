//
//  ConversationRemoteDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Combine
import Supabase

protocol ConversationRemoteDataSource {
    func fetchConversations(
        _ conversationIdentifiers: [UUID]
    ) async throws -> [ConversationResponse]
    func insertNewMessage(_ request: NewMessageRequest) async throws
}

final class DefaultConversationRemoteDataSource: ConversationRemoteDataSource {
    
    // MARK: Property(s)
    
    private let supabase: SupabaseClient
    
    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }
    
    // MARK: Function(s)
    
    func fetchConversations(
        _ conversationIdentifiers: [UUID]
    ) async throws -> [ConversationResponse] {
        return try await supabase
            .from("conversations")
            .select()
            .in("id", values: conversationIdentifiers)
            .execute()
            .decodeJSON()
    }
    
    func insertNewMessage(_ request: NewMessageRequest) async throws {
        try await supabase
            .from("messages")
            .insert(request)
            .execute()
    }
}
