//
//  FetchConversationSummaries.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Combine
import Foundation

final class FetchConversationSummaries {
    
    // MARK: Type(s)
    
    enum UseCaseError: Error {
        case noConversations
        case unknown
    }
    
    // MARK: Function(s)
    
    func execute() -> AnyPublisher<ConversationSummary, UseCaseError> {
        return Empty().eraseToAnyPublisher()
    }
}
