//
//  MockChatRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Combine
import Foundation

final class MockChatRepository: ChatRepository {
    
    // MARK: Property(s)
    
    var injectedError: ChatRepositoryError?
    
    // MARK: Function(s)
    
    func sendMessage(
        text: String,
        senderID: UUID,
        channelID: UUID
    ) -> AnyPublisher<Void, ChatRepositoryError> {
        Future { promise in
            if let error = self.injectedError {
                promise(.failure(error))
            } else {
                promise(.success(()))
            }
            self.injectedError = nil
        }
        .eraseToAnyPublisher()
    }
}
