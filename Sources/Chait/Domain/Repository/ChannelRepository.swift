//
//  ChatRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine

enum ChannelRepositoryError: Error {
    case noAvailableChannels
    case unknown
}

protocol ChannelRepository {
    func fetchAllChannels() -> AnyPublisher<[Channel], ChannelRepositoryError>
}
