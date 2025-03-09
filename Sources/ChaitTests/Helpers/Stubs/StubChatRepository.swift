//
//  StubChatRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation
import Combine

final class StubChatRepository: ChatRepository {
    
    private let sendMessageError: SendMessageError?
    private let listenMessagesError: ListenMessagesError?
    private let fetchChatHistoryError: FetchChatHistoryError?
    
    private let expectedMessages: [Message]
    
    init(
        failWithSendMessageError: SendMessageError? = nil,
        failWithListenMessagesError: ListenMessagesError? = nil,
        failWithFetchChatHistoryError: FetchChatHistoryError? = nil,
        succeedWith messages: [Message] = []
    ) {
        self.sendMessageError = failWithSendMessageError
        self.listenMessagesError = failWithListenMessagesError
        self.fetchChatHistoryError = failWithFetchChatHistoryError
        self.expectedMessages = messages
    }
    
    func sendMessage(
        text: String,
        senderID: UUID,
        channelID: UUID
    ) -> AnyPublisher<Void, SendMessageError> {
        guard let sendMessageError else {
            return Just(())
                .setFailureType(to: SendMessageError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: sendMessageError).eraseToAnyPublisher()
    }
    
    func startListeningMessages(channelID: UUID) -> AnyPublisher<[Message], ListenMessagesError> {
        guard let listenMessagesError else {
            return expectedMessages.publisher
                .map { [$0] }
                .setFailureType(to: ListenMessagesError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: listenMessagesError).eraseToAnyPublisher()
    }
    
    func fetchHistory(
        channelID: UUID,
        offset: Int,
        maxItemsCount: Int
    ) -> AnyPublisher<[Message], FetchChatHistoryError> {
        guard let fetchChatHistoryError else {
            return Just([])
                .setFailureType(to: FetchChatHistoryError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: fetchChatHistoryError).eraseToAnyPublisher()
    }
}
