//
//  ChannelRepositoryImplementation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

final class DefaultChannelRepository: ChannelRepository {
    
    // MARK: Property(s)
    
    private let dataSource: RemoteChannelsDataSource
    
    init(dataSource: RemoteChannelsDataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: Function(s)
    
    func fetchChannels(userID: UUID) -> AnyPublisher<[Channel], FetchChannelListUseCaseError> {
        dataSource.fetchChannelMembership(userID: userID)
            .flatMap { memberships in
                guard !memberships.isEmpty else {
                    return Fail<[ChannelResponse], RemoteChannelsDataSourceError>(error: .noItems)
                        .eraseToAnyPublisher()
                }
                return self.dataSource.fetchChannels(for: memberships)
            }
            .mapError { dataSourceError in
                switch dataSourceError {
                case .noItems:
                    return .noChannels
                default: 
                    return .fetchFailed
                }
            }
            .map { channelResponses in
                channelResponses.map { Channel(channelID: $0.channelID, title: $0.title) }
            }
            .eraseToAnyPublisher()
    }
}
