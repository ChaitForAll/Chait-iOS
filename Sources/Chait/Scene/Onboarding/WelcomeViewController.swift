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
    private let getStartedButton = UIButton()
    private let alreadyHaveAccountButton = UIButton()
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        fillContentText()
        configureViewStyle()
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
    
    private func fillContentText() {
        titleLabel.text = "Welcome to Chait"
        descriptionLabel.text = "Simple chatting \n Just a little bit \"botter\""
    }
    
    private func configureViewStyle() {
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        welcomeBannerStack.setCustomSpacing(13, after: appIconImageView)
        welcomeBannerStack.setCustomSpacing(28, after: titleLabel)
        buttonStack.setCustomSpacing(8, after: getStartedButton)
        
        let backgroundColor = UIColor { $0.isDarkMode ? UIColor.white : UIColor.black }
        let fontColor = UIColor { $0.isDarkMode ? UIColor.darkText : UIColor.white }
        
        var getStartedButtonConfiguration = UIButton.Configuration.filled()
        getStartedButtonConfiguration.title = "Get Started"
        getStartedButtonConfiguration.baseBackgroundColor = backgroundColor
        getStartedButtonConfiguration.baseForegroundColor = fontColor
        getStartedButton.configuration = getStartedButtonConfiguration
        getStartedButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        getStartedButton.addAction(
            UIAction { _ in
                // TODO: handle registration
            },
            for: .touchUpInside
        )
        
        var alreadyHaveAccountConfiguration = UIButton.Configuration.bordered()
        alreadyHaveAccountConfiguration.title = "I already have an account"
        alreadyHaveAccountConfiguration.baseBackgroundColor = .systemGray6
        alreadyHaveAccountConfiguration.baseForegroundColor = .label
        alreadyHaveAccountConfiguration.background.strokeColor = .lightGray
        alreadyHaveAccountButton.configuration = alreadyHaveAccountConfiguration
        alreadyHaveAccountButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        alreadyHaveAccountButton.addAction(
            UIAction { [weak self] _ in
                self?.coordinator?.toAuthenticationFlow()
            },
            for: .touchUpInside
        )
        
        let titleImage = UIImage(systemName: "message.fill")
        let titleImageColor = UIColor { $0.isDarkMode ? UIColor.white : UIColor.black }
        let titleImageConfig = UIImage.SymbolConfiguration(pointSize: 80)
            .applying(UIImage.SymbolConfiguration(paletteColors: [titleImageColor]))
        appIconImageView.image = titleImage?.applyingSymbolConfiguration(titleImageConfig)
    }
}

private extension UITraitCollection {
    
    var isDarkMode: Bool {
        return userInterfaceStyle == .dark
    }
}
