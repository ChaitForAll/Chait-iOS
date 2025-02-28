//
//  NewMessagesRequest.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct NewMessagesRequest: Encodable {
    let text: String
    let senderID: UUID
    let channelID: UUID
}
