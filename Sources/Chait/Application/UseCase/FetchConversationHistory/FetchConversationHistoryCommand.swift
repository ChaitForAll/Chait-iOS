//
//  FetchConversationHistoryCommand.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

enum MessageQuery {
    case mostRecent
    case before(Message)
}

struct FetchConversationHistoryCommand {
    let query: MessageQuery
}
