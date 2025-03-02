//
//  FetchChannelListUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum FetchChannelListUseCaseError: Error {
    case noChannels
    case networkError
    case fetchFailed
}

protocol FetchChannelListUseCase {
    func fetchChannels(_ userID: UUID) -> AnyPublisher<[Channel], FetchChannelListUseCaseError>
}

final class DefaultFetchChannelListUseCase: FetchChannelListUseCase {
    
    // MARK: Property(s)
    
    private let repository: ChannelRepository
    
    init(repository: ChannelRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func fetchChannels(_ userID: UUID) -> AnyPublisher<[Channel], FetchChannelListUseCaseError> {
        return repository.fetchChannels(userID: userID)
    }
}
