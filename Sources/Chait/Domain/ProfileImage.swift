//
//  ProfileImage.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

struct ProfileImage {
    
    // MARK: Property(s)
    
    let imageURL: URL
    
    // MARK: Function(s)
    
    func isValid() -> Bool {
        let validImageExtensions = ["jpg", "jpeg"]
        let validations = [
            validImageExtensions.contains(imageURL.pathExtension.lowercased()),
        ]
        return !validations.contains(false)
    }
}
