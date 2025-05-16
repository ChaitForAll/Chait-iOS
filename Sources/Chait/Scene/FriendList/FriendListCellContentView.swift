//
//  FriendListCellContentView.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit

final class FriendListCellContentView: UIView,  UIContentView {

    // MARK: Property(s)
    
    var configuration: any UIContentConfiguration
    
    // MARK: Initializer(s)
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Function(s)
}
