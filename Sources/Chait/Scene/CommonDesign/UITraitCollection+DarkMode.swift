//
//  UITraitCollection+DarkMode.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit

extension UITraitCollection {
    var isDarkMode: Bool {
        return userInterfaceStyle == .dark
    }
}
