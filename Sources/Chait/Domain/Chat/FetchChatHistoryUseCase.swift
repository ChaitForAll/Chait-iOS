//
//  FetchMessagesUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum FetchChatHistoryError: Error {
    case endOfHistoryError
    case networkError
    case unknownError
}

protocol FetchChatHistoryUseCase {
    func fetchHistory(channelID: UUID, messagesOffset: Int, maxItemsCount: Int) -> AnyPublisher<[Message], FetchChatHistoryError>
}

final class DefaultFEtchChatHistoryUseCase: FetchChatHistoryUseCase {
    
    private let repository: ChatRepository
    
    init(repository: ChatRepository) {
        self.repository = repository
    }
    
    func fetchHistory(channelID: UUID, messagesOffset: Int, maxItemsCount: Int) -> AnyPublisher<[Message], FetchChatHistoryError> {
        repository.fetchHistory(channelID: channelID, offset: messagesOffset, maxItemsCount: maxItemsCount)
            .eraseToAnyPublisher()
    }
}
