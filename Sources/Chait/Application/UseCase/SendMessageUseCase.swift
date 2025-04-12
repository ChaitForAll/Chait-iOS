//
//  SendMessageUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

enum SendMessageError: Error {
    case sendMessageFailed
    case unknown
}

protocol SendMessageUseCase {
    func sendMessage(text: String, senderID: UUID, channelID: UUID) -> AnyPublisher<Void, SendMessageError>
}

final class DefaultSendMessageUseCase: SendMessageUseCase {
    
    // MARK: Property(s)
    
    private let chatRepository: ChatRepository
    
    init(repository: ChatRepository) {
        self.chatRepository = repository
    }
    
    // MARK: Function(s)
    
    func sendMessage(text: String, senderID: UUID, channelID: UUID) -> AnyPublisher<Void, SendMessageError> {
        chatRepository
            .sendMessage(text: text, senderID: senderID, channelID: channelID)
            .eraseToAnyPublisher()
    }
}
