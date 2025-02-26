//
//  ListenMessagesUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum ListenMessagesError: Error {
    case networkError
    case unknown
}

protocol ListenMessagesUseCase {
    func startListening(channelID: UUID) -> AnyPublisher<[Message], ListenMessagesError>
}

final class DefaultListenMessagesUseCase: ListenMessagesUseCase {
    
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func startListening(channelID: UUID) -> AnyPublisher<[Message], ListenMessagesError> {
        chatRepository
            .startListeningMessages(channelID: channelID)
            .eraseToAnyPublisher()
    }
}
