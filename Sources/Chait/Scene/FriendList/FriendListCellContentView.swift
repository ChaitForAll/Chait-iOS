//
//  FriendListCellContentView.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit

final class FriendListCellContentView: UIView,  UIContentView {
    struct Configuration: UIContentConfiguration {
        var image: UIImage?
        var name: String?
        var status: String?
        var imageToTextSpacing: CGFloat = 8
        var imageWidth: CGFloat = 55
        
        func makeContentView() -> any UIView & UIContentView {
            FriendListCellContentView(configuration: self)
        }
        
        func updated(for state: any UIConfigurationState) -> Self {
            return self
        }
    }
    
    // MARK: Property(s)
    
    private let contentStack = UIStackView()
    private let imageView = UIImageView()
    private let userInfoStack = UIStackView()
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    
    private var imageWidthConstraint: NSLayoutConstraint?
    
    // MARK: Override(s) & Requirement(s)
    
    var configuration: any UIContentConfiguration {
        didSet {
            apply(configuration: configuration)
        }
    }
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        configureLayoutHierarchy()
        configureLayoutStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Function(s)
    
    private func configureLayoutHierarchy() {
        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(userInfoStack)
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 55)
        imageWidthConstraint?.isActive = true
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        userInfoStack.addArrangedSubview(nameLabel)
        userInfoStack.addArrangedSubview(statusLabel)
    }
    
    private func configureLayoutStyle() {
        userInfoStack.axis = .vertical
        userInfoStack.distribution = .fillEqually
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 0.5 * (55)
        imageView.clipsToBounds = true
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        statusLabel.font = .preferredFont(forTextStyle: .subheadline)
        layoutMargins = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    }
    
    private func apply(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {
            return
        }
        imageView.image = configuration.image
        nameLabel.text = configuration.name
        statusLabel.text = configuration.status
        contentStack.setCustomSpacing(configuration.imageToTextSpacing, after: imageView)
        imageWidthConstraint?.constant = configuration.imageWidth
    }
}
