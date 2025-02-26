//
//  MockRemoteMessagesDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation
import Combine

final class MockRemoteMessagesDataSource: RemoteMessagesDataSource {
    
    private let sendMessagesSubject: PassthroughSubject<Void, RemoteMessagesDataSourceError> = .init()
    private let listenMessagesSubject: PassthroughSubject<[MessageResponse], RemoteMessagesDataSourceError> = .init()
    
    func sendMessage(text: String, senderID: UUID, channelID: UUID) -> AnyPublisher<Void, RemoteMessagesDataSourceError> {
        return sendMessagesSubject.eraseToAnyPublisher()
    }
    
    func startListeningMessages(channelID: UUID) -> AnyPublisher<[MessageResponse], RemoteMessagesDataSourceError> {
        return listenMessagesSubject.eraseToAnyPublisher()
    }
    
    // MARK: Simulator(s)
    
    func simulateSendMessagesSuccess() {
        sendMessagesSubject.send(())
    }
    
    func simulateSendMessageError(_ error: RemoteMessagesDataSourceError) {
        sendMessagesSubject.send(completion: .failure(error))
    }
    
    func simulateReceiveMessageResponses(_ responses: [MessageResponse]) {
        listenMessagesSubject.send(responses)
    }
    
    func simulateReceiveErrorListeningMessages(_ error: RemoteMessagesDataSourceError) {
        listenMessagesSubject.send(completion: .failure(error))
    }
}
