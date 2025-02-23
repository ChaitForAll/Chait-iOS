//
//  Authentication.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Combine

enum SendMessageError: Error {
    case invalidMessageInput
    case unknown
}

protocol SendMessageUseCase {
    func sendMessage(_ command: SendMessageCommand) -> AnyPublisher<UserMessage, SendMessageError>
}

final class DefaultSendMessageUseCase: SendMessageUseCase {
    
    // MARK: Property(s)
    
    private let messagesRepository: MessagesRepository
    
    init(messagesRepository: MessagesRepository) {
        self.messagesRepository = messagesRepository
    }
    
    // MARK: Function(s)
    
    func sendMessage(_ command: SendMessageCommand) -> AnyPublisher<UserMessage, SendMessageError> {
        
        guard command.isMessageTextValid() else {
            return Fail<UserMessage, SendMessageError>(error: .invalidMessageInput)
                .eraseToAnyPublisher()
        }
        
        return messagesRepository
            .sendMessage(command.text, senderID: command.senderID, toChannelID: command.targetChannelID)
            .mapError { _ in return SendMessageError.unknown }
            .eraseToAnyPublisher()
    }
}
