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
                        .map { ConversationSummary($0) }
                    promise(.success(conversationSummaries))
                } catch {
                    promise(.failure(.fetchFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func sendMessage(_ newMessage: NewMessage) -> AnyPublisher<Message, ConversationError> {
        return Future { promise in
            Task {
                do {
                    let response = try await self.conversationRemote.insertNewMessage(
                        NewMessageRequest(
                            text: newMessage.text,
                            sender: newMessage.senderID,
                            conversationId: newMessage.conversationID
                        )
                    )
                    let message = Message(
                        text: response.text,
                        messageID: response.messageID,
                        senderID: response.senderID,
                        conversationID: response.conversationID,
                        createdAt: response.createdAt
                    )
                    promise(.success(message))
                } catch {
                    promise(.failure(.sendMessageFailed))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func startListening(_ conversationID: UUID) -> AnyPublisher<[Message], ConversationError> {
        return conversationRemote.startListeningInsertions(conversationID)
            .mapError { conversationError in
                switch conversationError {
                default:
                    return .listeningMessagesFailed
                }
            }
            .map { responses in
                return responses.map { response in
                    Message(
                        text: response.text,
                        messageID: response.messageID,
                        senderID: response.senderID,
                        conversationID: response.conversationID,
                        createdAt: response.createdAt
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchHistory(_ conversationID: UUID, historyOffset: Int, maxItems: Int) -> AnyPublisher<[Message], ConversationError> {
        return conversationRemote
            .readHistory(channelID: conversationID, historyOffset: historyOffset, maxItemsCount: maxItems)
            .mapError { datasourceError in
                switch datasourceError {
                case .unknown:
                    return ConversationError.fetchFailed
                case .endOfItems:
                    return ConversationError.endOfItems
                }
            }
            .map { responses in
                return responses.map { response in
                    Message(
                        text: response.text,
                        messageID: response.messageID,
                        senderID: response.senderID,
                        conversationID: response.conversationID,
                        createdAt: response.createdAt
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
