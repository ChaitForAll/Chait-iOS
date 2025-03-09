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
}
