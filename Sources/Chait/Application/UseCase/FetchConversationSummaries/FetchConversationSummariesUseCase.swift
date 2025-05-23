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
    
    func execute() -> AnyPublisher<[ConversationSummary], ExecutionError> {
        print(#function)
        return conversationRepository.fetchConversationDetails()
            .mapError { error in
                print(error)
                return ExecutionError.unknown
            }
            .flatMap { conversationDetails in
                let conversationIDs = conversationDetails.map(\.id)
                return self.messageRepository.fetchLastMessageDetails(conversationIDs)
                    .mapError { _ in ExecutionError.unknown }
                    .flatMap { messageDetails in
                        let senderIDs = messageDetails.map(\.senderID)
                        return self.userRepository.fetchUserDetails(senderIDs)
                            .mapError { _ in ExecutionError.unknown }
                            .flatMap { userDetails in
                                let messageDetails: [MessageDetail] = messageDetails
                                let userDetails: [UserDetail] = userDetails
                                var results: [ConversationSummary] = []
                                let threeZip = zip(conversationDetails, zip(messageDetails, userDetails))
                                for (conversationDetail, (messageDetail, userDetail)) in threeZip {
                                    let summary = ConversationSummary(
                                        conversationDetail: conversationDetail,
                                        messageDetail: messageDetail,
                                        userDetail: userDetail
                                    )
                                    results.append(summary)
                                }
                                return Just(results)
                                    .eraseToAnyPublisher()
                            }
                    }
            }
            .eraseToAnyPublisher()
    }
}
