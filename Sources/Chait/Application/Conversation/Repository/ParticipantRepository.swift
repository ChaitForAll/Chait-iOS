//
//  ParticipantRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Combine

enum ParticipantRepositoryError: Error {
    case unknown
}

protocol ParticipantRepository {
    func fetchParticipants(
        _ conversationIdentifier: UUID
    ) -> AnyPublisher<[Participant], ParticipantRepositoryError>
}
