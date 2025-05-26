//
//  FetchConversationHistoryCommand.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

enum MessageQuery {
    case mostRecent
    case before(Message)
}

struct FetchConversationHistoryCommand {
    let conversationIdentifier: UUID
    let query: MessageQuery
    let limit: Int
}
