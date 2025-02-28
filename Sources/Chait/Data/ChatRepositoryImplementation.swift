//
//  ChatRepositoryImplementation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

final class DefaultChatRepository: ChatRepository {
    
    // MARK: Property(s)
    
    private let remoteChatMessages: RemoteMessagesDataSource
    
    init(remoteChatMessages: RemoteMessagesDataSource) {
        self.remoteChatMessages = remoteChatMessages
    }
    
    // MARK: Function(s)
    
    func sendMessage(text: String, senderID: UUID, channelID: UUID) -> AnyPublisher<Void, SendMessageError> {
        remoteChatMessages
            .sendMessage(text: text, senderID: senderID, channelID: channelID)
            .mapError { remoteDataSourceError in
                switch remoteDataSourceError {
                case .networkError, .serverError, .unknownError(_):
                    return .sendMessageFailed
                }
            }
            .eraseToAnyPublisher()
    }
    
    func startListeningMessages(channelID: UUID) -> AnyPublisher<[Message], ListenMessagesError> {
        return remoteChatMessages
            .startListeningMessages(channelID: channelID)
            .mapError { remoteDataSourceError in
                switch remoteDataSourceError {
                case .networkError, .serverError, .unknownError(_): 
                    return .networkError
                }   
            }
            .map { messagesResponse in
                return messagesResponse.map { response in
                    Message(
                        text: response.text,
                        messageID: response.messageID,
                        senderID: response.senderID,
                        channelID: response.channelID,
                        createdAt: response.createdAt
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
