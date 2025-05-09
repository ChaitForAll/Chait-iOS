//
//  SingInViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Combine

final class SignInViewModel {
    
    enum ViewAction {
        case showInvalidInput
        case showIsLoading
        case coordinateToChat
    }
    
    // MARK: Property(s)
    
    var email: String = ""
    var password: String = ""
    var viewAction = PassthroughSubject<ViewAction, Never>()
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let authService: AuthenticationService
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    // MARK: Function(s)
    
    func onSignIn() {
        guard !email.isEmpty && !password.isEmpty else {
            viewAction.send(.showInvalidInput)
            return
        }
        viewAction.send(.showIsLoading)
        Task {
            do {
                try await authService.signIn(email, password: password)
                viewAction.send(.coordinateToChat)
            } catch {
                viewAction.send(.showInvalidInput)
            }
        }
    }
}
