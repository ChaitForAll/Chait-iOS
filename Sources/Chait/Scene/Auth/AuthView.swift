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
    
    weak var delegate: AuthenticationViewControllerDelegate?
    
    @FocusState private var focusedField: Field?
    @State private var viewModel: AuthViewModel
    private var cancelBag: Set<AnyCancellable> = .init()
    
    init(
        viewModel: AuthViewModel,
        delegate: AuthenticationViewControllerDelegate
    ) {
        self.viewModel =  viewModel
        self.delegate = delegate
    }
    
    var body: some View {
        VStack {
            Text("Welcome to Chait ").font(.title)
            TextField("Email", text: $viewModel.email)
                .frame(width: 200)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($focusedField, equals: .email)
            SecureField("Password", text: $viewModel.password)
                .frame(width: 200)
                .focused($focusedField, equals: .password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Sign In") {
                handleInputState()
            }
            .buttonStyle(.borderedProminent)
        }
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
