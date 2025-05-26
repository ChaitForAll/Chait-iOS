//
//  MessageRepositoryImplementation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine
import Supabase

final class MessageRepositoryImplementation: MessageRepository {
    
    // MARK: Property(s)
    
    private let messagesDataSource: RemoteMessagesDataSource
    private let authSession: AuthSession
    
    init(messagesDataSource: RemoteMessagesDataSource, authSession: AuthSession) {
        self.messagesDataSource = messagesDataSource
        self.authSession = authSession
    }
    
    // MARK: Private Function(s)
    
    func fetchMessages(
        from conversationIdentifier: UUID,
        query: MessageQuery,
        limit: Int
    ) async -> Result<[Message], MessageRepositoryError> {
        
        var filters: [RequestFilter] = []
        
        if case let .before(message) = query {
            filters.append(RequestFilter(
                column: "message_id",
                requestOperator: "eq",
                value: message.messageID.uuidString
            ))
        }
        
        do {
            let histories  = try await messagesDataSource.requestMessages(
                from: conversationIdentifier,
                filters: filters,
                limit: limit
            ).map {
                Message(
                    text: $0.text,
                    messageID: $0.messageID,
                    senderID: $0.senderID,
                    conversationID: $0.conversationID,
                    createdAt: $0.createdAt
                )
            }
            return .success(histories)
        } catch {
            return .failure(.unknown)
        }
    }
    
    func fetchLastMessageDetails(_ conversationIdentifiers: [UUID]) async throws -> [MessageDetail] {
        let lastMessages = try await messagesDataSource.fetchLastMessages(conversationIdentifiers)
        return lastMessages.map {
            MessageDetail(
                id: $0.messageID,
                text: $0.text,
                senderID: $0.senderID,
                conversationID: $0.conversationID
            )
        }
    }
    
    func create(_ newMessage: NewMessage) async -> Result<Message, MessageRepositoryError> {
        let newMessageRequest = NewMessageRequest(
            text: newMessage.text,
            sender: authSession.currentUserID,
            conversationId: newMessage.conversationID
        )
        do {
            let messageResponse = try await messagesDataSource.postNewMessage(newMessageRequest)
            let sentMessage = Message(
                text: messageResponse.text,
                messageID: messageResponse.messageID,
                senderID: messageResponse.senderID,
                conversationID: messageResponse.conversationID,
                createdAt: messageResponse.createdAt
            )
            return .success(sentMessage)
        } catch {
            return .failure(.unknown)
        }
    }
}

