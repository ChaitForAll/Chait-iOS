//
//  MessageRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine
import Foundation

enum MessageRepositoryError: Error {
    case unknown
}

protocol MessageRepository {
    func fetchMessages(
        from conversationIdentifier: UUID,
        query: MessageQuery,
        limit: Int
    ) async -> Result<[Message], MessageRepositoryError>
    func fetchLastMessageDetails(_ conversationIdentifiers: [UUID]) async throws-> [MessageDetail]
    func create(_ newMessage: NewMessage) async -> Result<Message, MessageRepositoryError>
}
