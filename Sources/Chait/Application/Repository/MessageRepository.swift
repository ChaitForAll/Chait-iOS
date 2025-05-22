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
    func fetchLastMessageDetails(
        _ conversationIdentifiers: [UUID]
    ) -> AnyPublisher<[MessageDetail], MessageRepositoryError>
}
