//
//  ChatRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine

enum ChannelRepositoryError: Error {
    case noAvailableChannels
    case serverError
    case unknown
}

protocol ChannelRepository {
    func fetchAllChannels() -> AnyPublisher<[Channel], ChannelRepositoryError>
    func createNewChannel(_ newChannel: NewChannel) -> AnyPublisher<Void, ChannelRepositoryError>
}
