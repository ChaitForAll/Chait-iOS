//
//  RemoteChannelsDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine
import Supabase

enum RemoteChannelsDataSourceError: Error {
    case networkError(URLError)
    case serverError(HTTPError)
    case postgRestError(PostgrestError)
    case decodingError(DecodingError)
    case noItems
}

protocol RemoteChannelsDataSource {
    func fetchChannelMembership(
        userID: UUID
    ) -> AnyPublisher<[ChannelMembershipResponse], RemoteChannelsDataSourceError>
    func fetchChannels(
        for memberShip: [ChannelMembershipResponse]
    ) -> AnyPublisher<[ChannelResponse], RemoteChannelsDataSourceError>
}
