//
//  ConversationMembershipRemoteDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Supabase

protocol ConversationMembershipRemoteDataSource {
    func fetchConversationMemberships(_ userID: UUID) async throws -> [ConversationMembershipResponse]
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
            .eq("userID", value: userID)
            .execute()
            .value
    }
}
