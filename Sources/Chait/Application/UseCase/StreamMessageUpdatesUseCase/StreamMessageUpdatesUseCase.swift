//
//  StreamMessageUpdatesUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

enum StreamMessageUpdatesError: Error {
    case accessDenied
    case unknown
}

protocol StreamMessageUpdatesUseCase {
    func execute(_ conversation: any Conversation) async throws -> AsyncStream<Message>
}

final class DefaultStreamMessageUpdatesUseCase: StreamMessageUpdatesUseCase {
    
    // MARK: Property(s)
    
    private let userRepository: UserRepository
    private let conversationRepository: ConversationRepository
    private let messagesRepository: MessageRepository
    
    init(
        userRepository: UserRepository,
        conversationRepository: ConversationRepository,
        messagesRepository: MessageRepository
    ) {
        self.userRepository = userRepository
        self.conversationRepository = conversationRepository
        self.messagesRepository = messagesRepository
    }
    
    // MARK: Function(s)
    
    func execute(_ conversation: any Conversation) async throws -> AsyncStream<Message> {
        let user = try await userRepository.fetchAppUser()
        guard user.canAccess(conversation) else {
            return .finished
        }
        return await messagesRepository.startListening(conversation.id)
    }
}

