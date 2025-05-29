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
    func execute(_ conversationID: UUID) async -> Result<[Message], StreamMessageUpdatesError>
}
