//
//  AuthViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import Combine

final class AuthViewModel: @unchecked Sendable {
    
    enum AuthViewModelError {
        case authFailed
    }
    
    // MARK: Property(s)
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: AuthViewModelError?
    @Published var isAuthenticated: Bool = false
    
    private let authService: AuthenticationService
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    // MARK: Function(s)
    
    func authenticate() {
        Task {
            do {
                try await authService.signIn(email, password: password)
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = .authFailed
                }
            }
        }
    }
    
}

