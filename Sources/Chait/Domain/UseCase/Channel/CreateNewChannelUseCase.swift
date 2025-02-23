//
//  CreateNewChannelUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine

enum CreateNewChannelError: Error {
    case invalidInput(String)
    case unknown
}

protocol CreateNewChannelUseCase {
    func create(newChannel: NewChannel ) -> AnyPublisher<Void, CreateNewChannelError>
} 

final class DefaultCreateNewChannelUseCase: CreateNewChannelUseCase {
    
    // MARK: Property(s)
    
    private let repository: ChannelRepository
    
    init(repository: ChannelRepository) {
        self.repository = repository
    }
    
    // MARK: Function(s)
    
    func create(newChannel: NewChannel) -> AnyPublisher<Void, CreateNewChannelError> {
        guard newChannel.isValid() else {
            return Result<Void, CreateNewChannelError>
                .Publisher(.failure(.invalidInput("Please check channel specifications.")))
                .eraseToAnyPublisher()
        }
        
        return repository
            .createNewChannel(newChannel)
            .mapError { _ in  return CreateNewChannelError.unknown }
            .eraseToAnyPublisher()
    }
}
