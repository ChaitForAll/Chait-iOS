//
//  StubRemoteMessages.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation
import Combine

final class StubRemoteMessages: RemoteMessagesDataSource {
    
    private let error: RemoteMessagesDataSourceError?
    private let messageResponses: [MessageResponse]
    
    init(failWith: RemoteMessagesDataSourceError? = nil, messageResponses: [MessageResponse] = []) {
        self.error = failWith
        self.messageResponses = messageResponses
    }
    
    func sendMessage(
        text: String,
        senderID: UUID,
        channelID: UUID
    ) -> AnyPublisher<Void, RemoteMessagesDataSourceError> {
        if let error {
            return Fail<Void, RemoteMessagesDataSourceError>(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(())
                .setFailureType(to: RemoteMessagesDataSourceError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func startListeningMessages(
        channelID: UUID
    ) -> AnyPublisher<[MessageResponse], RemoteMessagesDataSourceError> {
        if let error {
            return Fail<[MessageResponse], RemoteMessagesDataSourceError>(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(messageResponses)
                .setFailureType(to: RemoteMessagesDataSourceError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchHistory(
        channelID: UUID,
        historyOffset: Int, 
        maxItemsCount: Int
    ) -> AnyPublisher<[MessageResponse], RemoteMessagesDataSourceError> {
        if let error {
            return Fail<[MessageResponse], RemoteMessagesDataSourceError>(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(messageResponses)
                .setFailureType(to: RemoteMessagesDataSourceError.self)
                .eraseToAnyPublisher()
        }
    }
}
