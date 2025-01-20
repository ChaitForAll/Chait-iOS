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
    func send(_ message: NewUserMessage) -> AnyPublisher<UserMessage, SendMessageError>
}
