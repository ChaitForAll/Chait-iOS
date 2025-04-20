//
//  AuthenticationService.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import Supabase

    
final class AuthenticationService {
    
    // MARK: Property(s)
    
    var userID: UUID?
    
    var isAuthenticated: Bool {
        return userID != nil
    }
    
    private let supabase: SupabaseClient
    
    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }
    
    // MARK: Function(s)
    
    func signIn(_ email: String, password: String) async throws {
        let auth = try await supabase.auth.signIn(email: email, password: password)
        self.userID = auth.user.id
    }
    
    func logOut() async throws {
        try await supabase.auth.signOut()
    }
}
