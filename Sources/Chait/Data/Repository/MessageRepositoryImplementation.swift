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
    
    init(messagesDataSource: RemoteMessagesDataSource) {
        self.messagesDataSource = messagesDataSource
    }
    
    // MARK: Private Function(s)
    
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
}

