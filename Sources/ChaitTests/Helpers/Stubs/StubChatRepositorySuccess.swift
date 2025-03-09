//
//  StubChatRepositorySuccess.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation
import Combine

final class StubRemoteChannelDataSourceSucceed: RemoteChannelsDataSource {
    
    private let memberShipResponses: [ChannelMembershipResponse]
    private let channelResponses: [ChannelResponse]
    
    init(memberShipResponses: [ChannelMembershipResponse] = [], channelResponses: [ChannelResponse] = []) {
        self.memberShipResponses = memberShipResponses
        self.channelResponses = channelResponses
    }
    
    func fetchChannelMembership(
        userID: UUID
    ) -> AnyPublisher<[ChannelMembershipResponse], RemoteChannelsDataSourceError> {
        return Just(memberShipResponses)
            .flatMap { response in
                guard !response.isEmpty else {
                    return Fail<[ChannelMembershipResponse], RemoteChannelsDataSourceError>(error: .noItems)
                        .eraseToAnyPublisher()
                }
                return Just(response)
                    .setFailureType(to: RemoteChannelsDataSourceError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchChannels(
        for memberShip: [ChannelMembershipResponse]
    ) -> AnyPublisher<[ChannelResponse], RemoteChannelsDataSourceError> {
        Just(channelResponses)
            .flatMap { response in
                guard !response.isEmpty else {
                    return Fail<[ChannelResponse], RemoteChannelsDataSourceError>(error: .noItems)
                        .eraseToAnyPublisher()
                }
                return Just(response)
                    .setFailureType(to: RemoteChannelsDataSourceError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
