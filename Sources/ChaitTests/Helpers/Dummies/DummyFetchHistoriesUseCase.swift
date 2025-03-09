//
//  DummyFetchHistoriesUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation
import Combine

final class DummyFetchHistoriesUseCase: FetchChatHistoryUseCase {
    func fetchHistory(
        channelID: UUID,
        messagesOffset: Int,
        maxItemsCount: Int
    ) -> AnyPublisher<[Message], FetchChatHistoryError> {
        return Empty().eraseToAnyPublisher()
    }
}
