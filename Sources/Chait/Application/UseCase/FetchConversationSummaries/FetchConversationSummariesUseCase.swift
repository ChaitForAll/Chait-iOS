//
//  FetchConversationSummaries.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Combine
import Foundation

final class FetchConversationSummariesUseCase {
    
    // MARK: Type(s)
    
    enum ExecutionError: Error {
        case noConversations
        case unknown
    }
    
    // MARK: Property(s)
    
    private let conversationRepository: ConversationRepository
    
    init(conversationRepository: ConversationRepository) {
        self.conversationRepository = conversationRepository
    }
    
    // MARK: Function(s)
    
    func execute() -> AnyPublisher<[ConversationSummary], ExecutionError> {
        return conversationRepository.fetchConversationSummaryList()
    }
}
