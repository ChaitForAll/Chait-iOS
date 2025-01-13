//
//  Authentication.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Combine

enum MessageError: Error {
    case invalidMessageInput
    case sendMessageFailed
    case unknown
}

protocol SendMessageUseCase {
    func send(_ message: NewUserMessage) -> AnyPublisher<UserMessage, MessageError>
}
