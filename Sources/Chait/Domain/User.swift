//
//  User.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

enum UserError: Error {
    case invalidImage
}

protocol User: AnyObject, Identifiable {
    var id: UUID { get }
    var userName: String { get }
    var displayName: String { get set }
    var profileImage: ProfileImage? { get set }
    var createdAt: Date { get }
}

extension User {
    func changeDisplayName(_ newDisplayName: String) {
        guard !newDisplayName.isEmpty, displayName != newDisplayName else {
            return
        }
        self.displayName = newDisplayName
    }
}
