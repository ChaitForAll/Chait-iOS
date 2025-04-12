//
//  ChannelRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum ChannelRepositoryError: Error {
    case unknown(_ error: Error)
}

protocol ChannelRepository {
    func fetchChannels(userID: UUID) -> AnyPublisher<[Channel], FetchChannelListUseCaseError>
}
