//
//  FetchMessagesUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum FetchChatHistoryError: Error {
    case endOfHistory
    case networkError
}

protocol FetchChatHistoryUseCase {
    func fetchHistory(channelID: UUID, messagesOffset: Int, maxItemsCount: Int) -> AnyPublisher<[Message], FetchChatHistoryError>
}
}
