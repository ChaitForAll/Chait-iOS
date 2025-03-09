//
//  StubListenMessagesReceivesMessages.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation
import Combine

final class StubListenMessageReceiveMessages: ListenMessagesUseCase {
    
    private let messages: [Message]
    private let messagesSubject: PassthroughSubject<[Message], ListenMessagesError> = .init()
    
    init(messages: [Message] = []) {
        self.messages = messages
    }
    
    func startListening(channelID: UUID) -> AnyPublisher<[Message], ListenMessagesError> {
        return messagesSubject.eraseToAnyPublisher()
    }
    
    func fire() {
        messages.forEach { message in
            messagesSubject.send([message])
        }
    }
}
