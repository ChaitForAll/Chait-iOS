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
