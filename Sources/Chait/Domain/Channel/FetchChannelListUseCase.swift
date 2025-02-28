//
//  FetchChannelListUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum FetchChannelListUseCaseError: Error {
    case unknown(_ error: Error)
}

protocol FetchChannelListUseCase {
    func fetchChannels(_ userID: UUID) -> AnyPublisher<[Channel], FetchChannelListUseCaseError>
}
