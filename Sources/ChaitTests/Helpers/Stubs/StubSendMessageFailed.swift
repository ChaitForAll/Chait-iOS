//
//  StubSendMessageFailed.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Combine
import Foundation

final class StubSendMessageFailed: SendMessageUseCase {
    
    private let error: SendMessageError
    
    init(withError: SendMessageError = .unknown) {
        self.error = withError
    }
    
    func sendMessage(
        text: String,
        senderID: UUID,
        channelID: UUID
    ) -> AnyPublisher<Void, SendMessageError> {
        return Result<Void, SendMessageError>
            .failure(.sendMessageFailed)
            .publisher.eraseToAnyPublisher()
    }
}
