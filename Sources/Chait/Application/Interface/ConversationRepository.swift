//
//  ConversationRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Combine

protocol ConversationRepository {
    func fetchConversationSummaryList(_ userID: UUID) -> AnyPublisher<[ConversationSummary], ConversationError>
    func sendMessage(_ newMessage: NewMessage) -> AnyPublisher<Message, ConversationError>
    func startListening(_ conversationID: UUID) -> AnyPublisher<[Message], ConversationError>
    func fetchHistory(
        _ conversationID: UUID,
        historyOffset: Int,
        maxItems: Int
    ) -> AnyPublisher<[Message], ConversationError>
}
