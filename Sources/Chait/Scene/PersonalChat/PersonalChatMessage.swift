//
//  PersonalChatMessage.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct PersonalChatMessage: Identifiable {
    let id: UUID
    let text: String
    let senderID: UUID
    let createdAt: Date
}
