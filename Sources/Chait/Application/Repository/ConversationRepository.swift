//
//  ConversationRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Combine

enum ConversationRepositoryError: Error {
    case unknown
}

protocol ConversationRepository {
    func startListening(_ conversationID: UUID) -> AnyPublisher<[Message], ConversationError>
    func fetchHistory(
        _ conversationID: UUID,
        historyOffset: Int,
        maxItems: Int
    ) -> AnyPublisher<[Message], ConversationError>
    func fetchConversationDetails() async throws -> [ConversationDetail]
    func fetchConversation(_ conversationID: UUID) async -> Result<ConversationType, ConversationError>
}
