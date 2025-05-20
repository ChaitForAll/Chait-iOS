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
    case sendMessageFailed
}

protocol ConversationUseCase {
    func sendMessage(_ newMessage: NewMessage) -> AnyPublisher<Message, ConversationError>
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
    
    init(conversationRepository: ConversationRepository) {
        self.conversationRepository = conversationRepository
    }
    
    // MARK: Function(s)
    
    func sendMessage(_ newMessage: NewMessage) -> AnyPublisher<Message, ConversationError> {
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
