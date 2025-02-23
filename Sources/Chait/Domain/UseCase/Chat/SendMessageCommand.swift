//
//  SendMessageCommand.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation

struct SendMessageCommand {
    let senderID: UUID
    let targetChannelID: UUID
    let text: String
    
    func isMessageTextValid() -> Bool {
        let validations: [Bool] = [!text.isEmpty]
        return validations.allSatisfy { $0 == true }
    }
}
