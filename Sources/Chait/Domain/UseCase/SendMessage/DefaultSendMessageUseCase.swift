//
//  DefaultSendMessageUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Combine

final class DefaultSendMessageUseCase: SendMessageUseCase {
    
    // MARK: Property(s)
    
    private let messagesRepository: MessagesRepository
    
    init(messagesRepository: MessagesRepository) {
        self.messagesRepository = messagesRepository
    }
    
    // MARK: Function(s)
    
    func send(_ newMessage: NewUserMessage) -> AnyPublisher<UserMessage, SendMessageError> {
        guard newMessage.isValid() else {
            return Result<UserMessage, SendMessageError>
                .Publisher(.invalidMessageInput)
                .eraseToAnyPublisher()
        }
        return messagesRepository.create(newMessage)
            .mapError { error in
                switch error {
                case .unknown:
                    return SendMessageError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
