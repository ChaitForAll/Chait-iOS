//
//  FetchChannelListUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine

enum FetchChannelListUseCaseError: Error {
    case unknown(_ error: Error)
}

protocol FetchChannelListUseCase {
    func fetchChannels() -> AnyPublisher<[Channel], FetchChannelListUseCaseError>
}
