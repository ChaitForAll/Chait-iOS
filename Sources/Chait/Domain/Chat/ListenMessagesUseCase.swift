//
//  ListenMessagesUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

protocol ListenMessagesUseCase {
    func startListening(channelID: UUID) -> AnyPublisher<[Message], Never>
}

final class DefaultListenMessagesUseCase: ListenMessagesUseCase {
    
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func startListening(channelID: UUID) -> AnyPublisher<[Message], Never> {
        chatRepository
            .startListeningMessages(channelID: channelID)
            .eraseToAnyPublisher()
    }
}
