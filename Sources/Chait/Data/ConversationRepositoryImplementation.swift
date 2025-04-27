//
//  ConversationRepositoryImplementation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import Combine

final class ConversationRepositoryImplementation: ConversationRepository {
    
    // MARK: Property(s)
    
    private let conversationRemote: ConversationRemoteDataSource
    private let conversationMembershipRemote: ConversationMembershipRemoteDataSource
    private let userRemote: UserRemoteDataSource
    
    init(
        conversationRemote: ConversationRemoteDataSource,
        conversationMembershipRemote: ConversationMembershipRemoteDataSource,
        userRemote: UserRemoteDataSource
    ) {
        self.conversationRemote = conversationRemote
        self.conversationMembershipRemote = conversationMembershipRemote
        self.userRemote = userRemote
    }
    
    // MARK: Function(s)
    
    func fetchConversationSummaryList(_ userID: UUID) -> AnyPublisher<[ConversationSummary], ConversationError> {
        return Future { promise in
            Task {
                do {
                    let memberships = try await self.conversationMembershipRemote.fetchConversationMemberships(userID)
                    let conversationSummaries = try await self.conversationRemote
                        .fetchConversations(memberships.map { $0.conversationID })
                        .map { ConversationSummary(id: $0.id,title: $0.title) }
                    promise(.success(conversationSummaries))
                } catch {
                    promise(.failure(.fetchFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
