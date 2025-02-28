//
//  Bundle+Configuraiton.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

enum AppEnvironment {
    
    private enum Keys: String {
        case secretKey = "API_KEY"
        case projectURL = "PROJECT_URL"
    }
    
    private static var infoPListDictionary: [String: Any] {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        return dictionary
    }
    
    static let secretKey: String = {
        guard let key = AppEnvironment.infoPListDictionary[Keys.secretKey.rawValue] as? String else {
            fatalError("\(Keys.secretKey.rawValue) not found.")
        }
        return key
    }()
    
    static let projectURL: String = {
        guard let url = AppEnvironment.infoPListDictionary[Keys.projectURL.rawValue] as? String else {
            fatalError("\(Keys.projectURL.rawValue) not found.")
        }
        return url
    }()
}
