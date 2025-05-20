//
//  AuthenticationService.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import Supabase

    
protocol AuthenticationServiceDelegate: AnyObject {
    func authenticationComplete(with session: AuthSession)
}

final class AuthenticationService {
    
    // MARK: Property(s)
    weak var delegate: AuthenticationServiceDelegate?
    
    private let supabase: SupabaseClient
    
    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }
    
    // MARK: Function(s)
    
    func signIn(_ email: String, password: String) async throws {
        let auth = try await supabase.auth.signIn(email: email, password: password)
        let authSession = AuthSession(currentUserID: auth.user.id)
        delegate?.authenticationComplete(with: authSession)
    }
    
    func logOut() async throws {
        try await supabase.auth.signOut()
    }
}
