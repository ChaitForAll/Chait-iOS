//
//  UIButton+Loading.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import UIKit
    
extension UIButton {
    func showIsLoadingInCenter() {
        var loadingConfiguration = self.configuration
        loadingConfiguration?.title = nil
        loadingConfiguration?.showsActivityIndicator = true
        self.configuration = loadingConfiguration
    }
}
