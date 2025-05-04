//
//  MonoSecondaryBorderedButton.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit

final class MonoSecondaryBorderedButton: UIButton {
    
    // MARK: Override(s)
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: CGFloat(50))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var alreadyHaveAccountConfiguration = UIButton.Configuration.bordered()
        alreadyHaveAccountConfiguration.baseBackgroundColor = .systemGray6
        alreadyHaveAccountConfiguration.baseForegroundColor = .label
        alreadyHaveAccountConfiguration.background.strokeColor = .lightGray
        self.configuration = alreadyHaveAccountConfiguration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


