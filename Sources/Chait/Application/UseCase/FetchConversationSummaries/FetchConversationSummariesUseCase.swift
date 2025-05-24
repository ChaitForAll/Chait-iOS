//
//  FetchConversationSummaries.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Combine
import Foundation

final class FetchConversationSummariesUseCase {
    
    // MARK: Type(s)
    
    enum ExecutionError: Error {
        case noConversations
        case unknown
    }
    
    // MARK: Property(s)
    
    private let conversationRepository: ConversationRepository
    private let messageRepository: MessageRepository
    private let userRepository: UserRepository
    
    init(
        conversationRepository: ConversationRepository,
        messageRepository: MessageRepository,
        userRepository: UserRepository
    ) {
        self.conversationRepository = conversationRepository
        self.messageRepository = messageRepository
        self.userRepository = userRepository
    }
    
    // MARK: Function(s)
    
    func execute() async throws -> [ConversationSummary] {
        let conversationDetail = try await conversationRepository.fetchConversationDetails()
        let conversationLastMessages = try await messageRepository.fetchLastMessageDetails(conversationDetail.map(\.id))
        let messageSenders = try await userRepository.fetchUserDetails(conversationLastMessages.map(\.senderID))
        
        let messageDetails = Dictionary(uniqueKeysWithValues: conversationLastMessages.map { ($0.conversationID, $0)})
        let userDetails = Dictionary(uniqueKeysWithValues: messageSenders.map { ($0.id, $0) })
        
        return conversationDetail.compactMap { conversationDetail in
            guard let messageDetail = messageDetails[conversationDetail.id],
                  let userDetail = userDetails[messageDetail.senderID]
            else {
                return nil
            }
            return ConversationSummary(
                conversationDetail: conversationDetail,
                messageDetail: messageDetail,
                userDetail: userDetail
            )
        }
    }
}
