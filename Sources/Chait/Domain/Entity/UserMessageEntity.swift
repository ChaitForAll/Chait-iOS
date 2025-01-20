//
//  Entity.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct UserMessage: Identifiable {
    let id: UUID
    let senderID: UUID
    let channelID: UUID
    let text: String
    let createdAt: Date
    let updatedAt: Date
}
