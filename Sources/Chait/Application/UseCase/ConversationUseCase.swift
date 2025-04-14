//
//  ConversationUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Combine

enum ConversationError: Error {
    case fetchFailed
}

protocol ConversationUseCase {
    func fetchConversationList() -> AnyPublisher<[any Conversation], ConversationError>
}
