//
//  ConversationMembershipRemoteDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Supabase

protocol ConversationMembershipRemoteDataSource {
    func fetchConversationMemberships(
        _ userID: UUID
    ) async throws -> [ConversationMembershipResponse]
    func fetchMembers(_ conversationID: UUID) async throws -> [UUID]
}

final class DefaultConversationMembershipRemoteDataSource: ConversationMembershipRemoteDataSource {
    
    // MARK: Property(s)
    
    private let supabase: SupabaseClient
    
    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }
    
    // MARK: Function(s)
    
    func fetchConversationMemberships(
        _ userID: UUID
    ) async throws -> [ConversationMembershipResponse] {
        return try await supabase
            .from("conversation_membership")
            .select()
            .eq("user_id", value: userID)
            .execute()
            .decodeJSON()
    }
    
    func fetchMembers(_ conversationID: UUID) async throws -> [UUID] {
        let responses: [ConversationMembershipResponse] =  try await supabase
            .from("conversation_membership")
            .select()
            .eq("conversation_id", value: conversationID)
            .execute()
            .decodeJSON()
        return responses.map { $0.userID }
    }
}
