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
    func fetchLastMessageDetails(_ conversationIdentifiers: [UUID]) async throws-> [MessageDetail]
    func create(_ newMessage: NewMessage) async -> Result<Message, MessageRepositoryError>
}
