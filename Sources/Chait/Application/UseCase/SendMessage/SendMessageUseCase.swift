//
//  SendMessageUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

enum SendMessageError: Error {
    case unknown
}

protocol SendMessageUseCaseInterface {
    func execute(_ command: SendMessageCommand) async -> Result<Message, SendMessageError>
}

final class SendMessageUseCase: SendMessageUseCaseInterface {
    
    // MARK: Property(s)
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    // MARK: Function(s)
    
    @discardableResult
    func execute(_ command: SendMessageCommand) async -> Result<Message, SendMessageError> {
        let newMessage = NewMessage(text: command.message, conversationID: command.conversationIdentifier)
        let sendingResult = await messageRepository.create(newMessage)
        return sendingResult.mapError { repositoryError in
            switch repositoryError {
            case .unknown: .unknown
            }
        }
    }
}
