//
//  ConversationRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Combine

protocol ConversationRepository {
    func fetchConversationList(_ userID: UUID) -> AnyPublisher<[ConversationType], ConversationError>
    func fetchConversationSummaryList(_ userID: UUID) -> AnyPublisher<[ConversationSummary], ConversationError>
}
