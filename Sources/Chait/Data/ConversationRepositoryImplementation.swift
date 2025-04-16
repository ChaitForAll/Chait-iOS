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
    
    func fetchConversationList(
        _ userID: UUID
    ) -> AnyPublisher<[ConversationType], ConversationError> {
        return Future { promise in
            Task {
                do {
                    let memberships = try await self.conversationMembershipRemote
                        .fetchConversationMemberships(userID)
                    let conversationResponses = try await self.conversationRemote
                        .fetchConversations(memberships.map { $0.conversationID })
                    var conversations: [ConversationType] = []
                    
                    for conversationResponse in conversationResponses {
                        let conversationType: ConversationType
                        let participants = try await self.fetchParticipants(conversationResponse.id)
                        
                        switch conversationResponse.conversationType {
                        case .private:
                            conversationType = .private(
                                conversationResponse
                                    .toPrivateConversation(participants: Set(participants))
                            )
                        case .group:
                            conversationType = .group(
                                conversationResponse
                                    .toGroupConversation(participants: Set(participants))
                            )
                        }
                        conversations.append(conversationType)
                    }
                    
                    promise(.success(conversations))
                } catch {
                    promise(.failure(.fetchFailed))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    private func fetchParticipants(_ conversationID: UUID) async throws -> [Participant] {
        let memberIdentifier = try await conversationMembershipRemote.fetchMembers(conversationID)
        let participantsResponse = try await userRemote.fetchUsers(memberIdentifier)
        let participants = participantsResponse.map { $0.toParticipant() }
        return participants
    }
}
