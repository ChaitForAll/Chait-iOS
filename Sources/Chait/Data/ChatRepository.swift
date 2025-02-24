//
//  ChatRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum ChatRepositoryError: Error {
    case networkError
    case unknown
}

protocol ChatRepository {
    func sendMessage(text: String, senderID: UUID, channelID: UUID) -> AnyPublisher<Void, ChatRepositoryError>
}
