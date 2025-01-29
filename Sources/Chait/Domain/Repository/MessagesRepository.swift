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
    func create(_ newMessage: NewUserMessage) -> AnyPublisher<UserMessage, MessageRepositoryError>
}
