//
//  ConversationResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation

enum ConversationTypeResponse: String, Decodable {
    case `private`
    case group
}

struct ConversationResponse: Decodable {
    let id: UUID
    let title: String
    let conversationType: ConversationTypeResponse
    let createdAt: Date
    let updatedAt: Date
}
