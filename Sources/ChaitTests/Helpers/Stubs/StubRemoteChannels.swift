//
//  StubRemoteChannelsDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation
import Combine

final class StubRemoteChannelsDataSource: RemoteChannelsDataSource {
    
    private let error: RemoteChannelsDataSourceError?
    private let memberships: [ChannelMembershipResponse]
    private let channels: [ChannelResponse]
    
    init(
        error: RemoteChannelsDataSourceError? = nil,
        memberships: [ChannelMembershipResponse] = [],
        channels: [ChannelResponse] = []
    ) {
        self.error = error
        self.memberships = memberships
        self.channels = channels
    }
    
    func fetchChannelMembership(
        userID: UUID
    ) -> AnyPublisher<[ChannelMembershipResponse], RemoteChannelsDataSourceError> {
        guard let error else {
            return Just(memberships)
                .setFailureType(to: RemoteChannelsDataSourceError.self)
                .eraseToAnyPublisher()
        }

        return Fail(error: error).eraseToAnyPublisher()
    }
    
    func fetchChannels(
        for memberShip: [ChannelMembershipResponse]
    ) -> AnyPublisher<[ChannelResponse], RemoteChannelsDataSourceError> {
        guard let error else {
            return Just(channels)
                .setFailureType(to: RemoteChannelsDataSourceError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: error).eraseToAnyPublisher()
    }
}
