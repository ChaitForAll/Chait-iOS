//
//  ConversationUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import Combine

enum ConversationError: Error {
    case fetchFailed
    case listeningMessagesFailed
    case endOfItems
}

protocol ConversationUseCase {
    func fetchConversationSummaryList() -> AnyPublisher<[ConversationSummary], ConversationError>
    func sendMessage(_ newMessage: NewMessage) -> AnyPublisher<Message, SendMessageError>
    func startListeningMessages(_ channelID: UUID) -> AnyPublisher<[Message], ConversationError>
    func fetchHistory(
        _ conversationID: UUID,
        historyOffset: Int,
        maxItems: Int
    ) -> AnyPublisher<[Message], ConversationError>
}

final class DefaultConversationUseCase: ConversationUseCase {
    
    // MARK: Property(s)
    
    private let conversationRepository: ConversationRepository
    private let userID: UUID
    
    init(conversationRepository: ConversationRepository, userID: UUID) {
        self.conversationRepository = conversationRepository
        self.userID = userID
    }
    
    // MARK: Function(s)
    
    func fetchConversationSummaryList(
    ) -> AnyPublisher<[ConversationSummary], ConversationError> {
        return conversationRepository.fetchConversationSummaryList(userID)
    }
    
    func sendMessage(_ newMessage: NewMessage) -> AnyPublisher<Message, SendMessageError> {
        conversationRepository.sendMessage(newMessage)
    }

    func startListeningMessages(
        _ conversationID: UUID
    ) -> AnyPublisher<[Message], ConversationError> {
        conversationRepository.startListening(conversationID)
    }
    
    func fetchHistory(
        _ conversationID: UUID,
        historyOffset: Int,
        maxItems: Int
    ) -> AnyPublisher<[Message], ConversationError> {
        return conversationRepository.fetchHistory(
            conversationID,
            historyOffset: historyOffset,
            maxItems: maxItems
        )
    }
}
