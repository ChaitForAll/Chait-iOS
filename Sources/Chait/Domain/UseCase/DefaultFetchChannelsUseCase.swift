//
//  DefaultFetchChannelsUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine

final class DefaultFetchChannelsUseCase: FetchChannelsUseCase {
    
    // MARK: Property(s)
    
    private let channelsRepository: ChannelRepository
    
    init(channelsRepository: ChannelRepository) {
        self.channelsRepository = channelsRepository
    }
    
    // MARK: Function(s)
    
    func fetchAllChannels() -> AnyPublisher<[Channel], FetchChannelsError> {
        channelsRepository.fetchAllChannels()
            .mapError { error in
                switch error {
                case .noAvailableChannels: return .emptyChannelList
                default: return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
