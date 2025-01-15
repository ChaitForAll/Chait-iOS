//
//  NewChannel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct NewChannel {
    let title: String
    
    func isValid() -> Bool {
        let validations: [Bool] = [
            !title.isEmpty,
            title != ""
        ]
        return validations.allSatisfy { $0 == true }
    }
}
