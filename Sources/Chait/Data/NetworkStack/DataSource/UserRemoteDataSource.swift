//
//  UserRemoteDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import Supabase

protocol UserRemoteDataSource {
    func fetchUser(_ userIdentifier: UUID) async throws -> UserResponse
    func fetchUsers(_ userIdentifiers: [UUID]) async throws -> [UserResponse]
}

final class DefaultUserRemoteDataSource: UserRemoteDataSource {
    
    // MARK: Property(s)
    
    private let supabase: SupabaseClient
    
    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }
    
    // MARK: Function(s)
    
    func fetchUser(_ userIdentifier: UUID) async throws -> UserResponse {
        return try await supabase
            .from("user_profile")
            .select()
            .eq("id", value: userIdentifier)
            .execute()
            .decodeJSON()
    }
    
    func fetchUsers(_ userIdentifiers: [UUID]) async throws -> [UserResponse] {
        return try await supabase
            .from("user_profile")
            .select()
            .in("id", values: userIdentifiers)
            .execute()
            .decodeJSON()
    }
}
