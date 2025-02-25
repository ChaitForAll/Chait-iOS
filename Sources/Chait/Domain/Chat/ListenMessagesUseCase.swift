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
