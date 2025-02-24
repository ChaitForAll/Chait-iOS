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
    func sendMessage(text: String, _ senderID: UUID, _ channelID: UUID) -> AnyPublisher<Void, SendMessageError>
}
