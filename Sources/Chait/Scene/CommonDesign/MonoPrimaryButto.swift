//
//  MonoPrimaryButton.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit


final class MonoPrimaryButton: UIButton {
    
    // MARK: Override(s)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let backgroundColor = UIColor { $0.isDarkMode ? UIColor.white : UIColor.black }
        let fontColor = UIColor { $0.isDarkMode ? UIColor.darkText : UIColor.white }
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = backgroundColor
        buttonConfiguration.baseForegroundColor = fontColor
        self.configuration = buttonConfiguration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
