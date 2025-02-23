//
//  MessagesRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum MessageRepositoryError: Error {
    case unknown
}

protocol MessagesRepository {
    var channelID: UUID { get }
    func sendMessage(
        _ messageText: String,
        senderID: UUID,
        toChannelID: UUID
    ) -> AnyPublisher<UserMessage, MessageRepositoryError>
}
