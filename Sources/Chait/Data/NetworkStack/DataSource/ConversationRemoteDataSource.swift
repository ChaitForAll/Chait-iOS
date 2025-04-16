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
            .decode(using: .convertFromSnakeCase)
    }
}
