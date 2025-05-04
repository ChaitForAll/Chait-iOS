//
//  SignInViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit

final class SignInViewController: UIViewController {
    
    // MARK: Property(s)
    
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
            inputStackView.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func configureViewStyle() {
        inputStackView.axis = .vertical
        emailInput.borderStyle = .roundedRect
        passwordInput.borderStyle = .roundedRect
        titleLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        descriptionLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        emailLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        passwordLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        descriptionLabel.textColor = .systemGray
        inputStackView.spacing = 22
    }
    
    private func fillContent() {
        titleLabel.text = "Sign In"
        descriptionLabel.text = "Welcome back!"
        emailInput.placeholder = "Enter your email"
        passwordInput.placeholder = "Enter your password"
        signInButton.setTitle("Sign In", for: .normal)
        emailLabel.text = "Email"
        passwordLabel.text = "Password"
    }
    
    private func configureButtonActions() {
        signInButton.addAction(
            UIAction { _ in
                // TODO: Add actual action
            },
            for: .touchUpInside
        )
    }
}
