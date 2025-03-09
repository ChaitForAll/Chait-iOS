//
//  DummyListenMessagesUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation
import Combine

struct DummyListenMessagesUseCase: ListenMessagesUseCase {
    func startListening(channelID: UUID) -> AnyPublisher<[Message], ListenMessagesError> {
        return Empty().eraseToAnyPublisher()
    }
}
