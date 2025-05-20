//
//  AppCoreContainer.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Supabase

struct AppCoreContainer {
    
    // MARK: Property(s)
    
    let supabaseClient: SupabaseClient = SupabaseClient(
        supabaseURL: AppEnvironment.projectURL,
        supabaseKey: AppEnvironment.secretKey
    )
    let authService: AuthenticationService
    
    init() {
        self.authService = AuthenticationService(supabase: supabaseClient)
    }
    
    // MARK: Function(s)
    
    func createSignInViewModel() -> SignInViewModel {
        return SignInViewModel(authService: authService)
    }
}
