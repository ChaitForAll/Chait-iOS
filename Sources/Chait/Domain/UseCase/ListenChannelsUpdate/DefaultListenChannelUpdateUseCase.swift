//
//  DefaultListenChannelUpdateUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Combine

final class DefaultListenChannelsUpdateUseCase: ListenChannelsUpdateUseCase {
    
    // MARK: Property(s)
    
    private let repository: ChannelRepository
    
    init(repository: ChannelRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func execute() -> AnyPublisher<ChannelUpdate, ListenChannelsUpdateError> {
        return repository.listenChannelUpdates()
            .mapError { repositoryError in
                switch repositoryError {
                default: return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
