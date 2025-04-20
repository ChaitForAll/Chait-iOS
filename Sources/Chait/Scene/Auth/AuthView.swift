//
//  AuthenticationViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import SwiftUI
import Combine

protocol AuthenticationViewControllerDelegate: AnyObject {
    func authenticationSucceed()
}

struct AuthView: View {
    
    private enum Field: Hashable {
        case email, password
    }
    
    var delegate: AuthenticationViewControllerDelegate?
    
    @FocusState private var focusedField: Field?
    @State private var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Welcome to Chait").font(.title)
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusedField, equals: .email)
            SecureField("Password", text: $viewModel.password)
                .focused($focusedField, equals: .password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Sign In") {
                handleInputState()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(width: 250)
        .onReceive(viewModel.$isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                delegate?.authenticationSucceed()
            }
        }
    }
    
    private func handleInputState() {
        if viewModel.email.isEmpty {
            focusedField = .email
        } else if viewModel.password.isEmpty {
            focusedField = .password
        } else {
            viewModel.authenticate()
        }
    }
}
