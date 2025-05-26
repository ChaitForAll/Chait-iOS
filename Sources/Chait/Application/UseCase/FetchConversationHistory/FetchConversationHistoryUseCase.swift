//
//  FetchConversationHistoryUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

enum FetchConversationHistoryError: Error {
    case unknown
}

protocol FetchConversationHistoryUseCase {
    func execute(
        _ command: FetchConversationHistoryCommand
    ) async -> Result<[ConversationHistoryItem], FetchConversationHistoryError>
}


