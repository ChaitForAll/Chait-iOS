//
//  Message.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

struct Message {
    let text: String
    let messageID: UUID
    let senderID: UUID
    let channelID: UUID
    let createdAt: Date
}
