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


final class DefaultFetchConversationHistory: FetchConversationHistoryUseCase {
    
    // MARK: Property(s)
    
    private let repository: MessageRepository
    
    init(repository: MessageRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func execute(
        _ command: FetchConversationHistoryCommand
    ) async -> Result<[ConversationHistoryItem], FetchConversationHistoryError> {
        await repository.fetchMessages(
            from: command.conversationIdentifier,
            query: command.query,
            limit: command.limit
        )
        .mapError { repositoryError in
            switch repositoryError {
            case .unknown: FetchConversationHistoryError.unknown
            }
        }
        .map { messages in
            messages.map { .message($0) }
        }
    }
}
