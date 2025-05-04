//
//  WelcomeViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class WelcomeViewController: UIViewController {
    
    // MARK: Property(s)
    
    var coordinator: AppCoordinator?
    
    private let welcomeBannerStack = UIStackView()
    private let appIconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let buttonStack = UIStackView()
    private let getStartedButton = MonoPrimaryButton()
    private let alreadyHaveAccountButton = MonoSecondaryBorderedButton()
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        fillContents()
        configureViewStyle()
        configureButtonActions()
    }
    
    // MARK: Private Function(s)
    
    private func configureViewHierarchy() {
        view.backgroundColor = .systemBackground
        view.addSubview(welcomeBannerStack)
        welcomeBannerStack.axis = .vertical
        welcomeBannerStack.alignment = .center
        welcomeBannerStack.addArrangedSubview(appIconImageView)
        welcomeBannerStack.addArrangedSubview(titleLabel)
        welcomeBannerStack.addArrangedSubview(descriptionLabel)
        welcomeBannerStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonStack)
        buttonStack.axis = .vertical
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillEqually
        buttonStack.addArrangedSubview(getStartedButton)
        buttonStack.addArrangedSubview(alreadyHaveAccountButton)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeBannerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeBannerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeBannerStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            buttonStack.centerXAnchor.constraint(equalTo: welcomeBannerStack.centerXAnchor),
            buttonStack.topAnchor.constraint(
                equalTo: welcomeBannerStack.bottomAnchor,
                constant: 45
            ),
        ])
    }
    
    private func fillContents() {
        titleLabel.text = "Welcome to Chait"
        descriptionLabel.text = "Simple chatting \n Just a little bit \"botter\""
        alreadyHaveAccountButton.setTitle("I already have an account", for: .normal)
        getStartedButton.setTitle("Get Started", for: .normal)
        let titleImage = UIImage(systemName: "message.fill")
        let titleImageColor = UIColor { $0.isDarkMode ? UIColor.white : UIColor.black }
        let titleImageConfig = UIImage.SymbolConfiguration(pointSize: 80)
            .applying(UIImage.SymbolConfiguration(paletteColors: [titleImageColor]))
        appIconImageView.image = titleImage?.applyingSymbolConfiguration(titleImageConfig)
    }
    
    private func configureViewStyle() {
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        welcomeBannerStack.setCustomSpacing(13, after: appIconImageView)
        welcomeBannerStack.setCustomSpacing(28, after: titleLabel)
        buttonStack.setCustomSpacing(8, after: getStartedButton)
        getStartedButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        alreadyHaveAccountButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func configureButtonActions() {
        getStartedButton.addAction(
            UIAction { _ in
                // TODO: handle registration
            },
            for: .touchUpInside
        )
        
        alreadyHaveAccountButton.addAction(
            UIAction { [weak self] _ in
                self?.coordinator?.toAuthenticationFlow()
            },
            for: .touchUpInside
        )
    }
}
