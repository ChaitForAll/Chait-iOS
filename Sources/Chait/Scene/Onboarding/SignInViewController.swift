//
//  SignInViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit
import Combine

final class SignInViewController: UIViewController {
    
    // MARK: Property(s)
    
    var viewModel: SignInViewModel?
    var coordinator: AppSessionCoordinator?
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    
    private let inputStackView: UIStackView = UIStackView()
    
    private let emailLabel: UILabel = UILabel()
    private let emailInput: UITextField = UITextField()
    
    private let passwordLabel: UILabel = UILabel()
    private let passwordInput: UITextField = UITextField()
    
    private let signInButton: MonoPrimaryButton = MonoPrimaryButton()
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureViewStyle()
        fillContent()
        configureButtonActions()
        
        emailInput
            .bind(to: \.email, on: viewModel)
            .store(in: &cancelBag)
        passwordInput
            .bind(to: \.password, on: viewModel)
            .store(in: &cancelBag)
        
        viewModel?.viewAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .showInvalidInput:
                    return
                case .showIsLoading:
                    self?.signInButton.showIsLoadingInCenter()
                case .coordinateToChat:
                    self?.coordinator?.start()
                }
            }
            .store(in: &cancelBag)
    }
    
    // MARK: Private Function(s)
    
    private func configureViewHierarchy() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(inputStackView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        inputStackView.addArrangedSubview(emailLabel)
        inputStackView.addArrangedSubview(emailInput)
        inputStackView.addArrangedSubview(passwordLabel)
        inputStackView.addArrangedSubview(passwordInput)
        inputStackView.addArrangedSubview(signInButton)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            inputStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            inputStackView.widthAnchor.constraint(equalToConstant: 350),
            emailInput.heightAnchor.constraint(equalTo: signInButton.heightAnchor),
            passwordInput.heightAnchor.constraint(equalTo: signInButton.heightAnchor)
        ])
    }
    
    private func configureViewStyle() {
        inputStackView.axis = .vertical
        emailInput.borderStyle = .roundedRect
        passwordInput.borderStyle = .roundedRect
        descriptionLabel.textColor = .systemGray
        titleLabel.font = .preferredFont(for: .largeTitle, weight: .bold)
        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        emailInput.autocapitalizationType = .none
        inputStackView.spacing = 22
        inputStackView.setCustomSpacing(11, after: emailLabel)
        inputStackView.setCustomSpacing(11, after: passwordLabel)
    }
    
    private func fillContent() {
        titleLabel.text = "Sign In"
        descriptionLabel.text = "Welcome back!"
        emailInput.placeholder = "Enter your email"
        emailInput.textContentType = .emailAddress
        passwordInput.placeholder = "Enter your password"
        passwordInput.textContentType = .password
        passwordInput.isSecureTextEntry = true
        emailLabel.text = "Email"
        passwordLabel.text = "Password"
        
        var buttonConfig = signInButton.configuration
        buttonConfig?.title = "Sign In"
        signInButton.configuration = buttonConfig
    }
    
    private func configureButtonActions() {
        signInButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel?.onSignIn()
            },
            for: .touchUpInside
        )
    }
}
