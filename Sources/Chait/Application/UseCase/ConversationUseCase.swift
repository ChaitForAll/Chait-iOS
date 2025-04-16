//
//  ConversationUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import Combine

enum ConversationError: Error {
    case fetchFailed
}

protocol ConversationUseCase {
    func fetchConversationList() -> AnyPublisher<[ConversationType], ConversationError>
    func fetchConversationSummaryList(_ userID: UUID) -> AnyPublisher<[ConversationSummary], ConversationError>
}

final class DefaultChatUseCase: ConversationUseCase {
    
    // MARK: Property(s)
    
    private let conversationRepository: ConversationRepository
    private let userID: UUID
    
    init(conversationRepository: ConversationRepository, userID: UUID) {
        self.conversationRepository = conversationRepository
        self.userID = userID
    }
    
    // MARK: Function(s)
    
    func fetchConversationList() -> AnyPublisher<[ConversationType], ConversationError> {
        return conversationRepository.fetchConversationList(userID)
    }
    
    func fetchConversationSummaryList(
        _ userID: UUID
    ) -> AnyPublisher<[ConversationSummary], ConversationError> {
        return conversationRepository.fetchConversationSummaryList(userID)
    }
}
