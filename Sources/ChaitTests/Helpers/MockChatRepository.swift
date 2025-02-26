//
//  MockChatRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Combine
import Foundation

final class MockChatRepository: ChatRepository {
    
    // MARK: Property(s)
    
    var injectedSendMessageError: SendMessageError?
    var injectedListenMessageError: ListenMessagesError?
    
    private var listenMessagesSubject: PassthroughSubject<[Message], ListenMessagesError> = .init()
    
    // MARK: Function(s)
    
    func sendMessage(
        text: String,
        senderID: UUID,
        channelID: UUID
    ) -> AnyPublisher<Void, SendMessageError> {
        Future { promise in
            if let error = self.injectedSendMessageError {
                promise(.failure(error))
            } else {
                promise(.success(()))
            }
            self.injectedSendMessageError = nil
        }
        .eraseToAnyPublisher()
    }
    
    func startListeningMessages(channelID: UUID) -> AnyPublisher<[Message], ListenMessagesError> {
        if let injectedListenMessageError {
            listenMessagesSubject.send(completion: .failure(injectedListenMessageError))
        }
        return listenMessagesSubject.eraseToAnyPublisher()
    }
    
    func sendMessages(_ message: Message) {
        listenMessagesSubject.send([message])
    }
}
