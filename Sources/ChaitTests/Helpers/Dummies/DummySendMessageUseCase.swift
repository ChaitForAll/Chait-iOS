//
//  DummySendMessageUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation
import Combine

struct DummySendMessageUseCase: SendMessageUseCase {
    func sendMessage(
        text: String,
        senderID: UUID,
        channelID: UUID
    ) -> AnyPublisher<Void, SendMessageError> {
        return Empty().eraseToAnyPublisher()
    }
}
