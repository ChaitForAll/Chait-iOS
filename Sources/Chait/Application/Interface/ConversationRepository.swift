//
//  ConversationRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Combine

protocol ConversationRepository {
    func fetchConversationSummaryList(_ userID: UUID) -> AnyPublisher<[ConversationSummary], ConversationError>
}
