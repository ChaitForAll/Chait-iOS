//
//  ChatRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum ChatRepositoryError: Error {
    case networkError
}

protocol ChatRepository {
    func sendMessage(text: String, senderID: UUID, channelID: UUID) -> AnyPublisher<Void, SendMessageError>
    func startListeningMessages(channelID: UUID) -> AnyPublisher<[Message], Never>
}
