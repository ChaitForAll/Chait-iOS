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

final class DefaultRemoteChannelsDataSource: RemoteChannelsDataSource {
    
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    func fetchChannelMembership(
        userID: UUID
    ) -> AnyPublisher<[ChannelMembershipResponse], RemoteChannelsDataSourceError> {
        return Future { promise in
            Task {
                do {
                    let membershipResponses: [ChannelMembershipResponse] = try await self.client
                        .from("channel_members")
                        .select()
                        .eq("member_id", value: userID)
                        .execute()
                        .value
                    
                    guard !membershipResponses.isEmpty else {
                       return promise(.failure(.noItems))
                    }
                    
                    promise(.success(membershipResponses))
                } catch let urlError as URLError {
                    promise(.failure(.networkError(urlError)))
                } catch let postgRestError as PostgrestError {
                    promise(.failure(.postgRestError(postgRestError)))
                } catch let httpError as HTTPError {
                    promise(.failure(.serverError(httpError)))
                }  catch let decodingError as  DecodingError {
                    promise(.failure(.decodingError(decodingError)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchChannels(
        for memberShip: [ChannelMembershipResponse]
    ) -> AnyPublisher<[ChannelResponse], RemoteChannelsDataSourceError> {
        return Future<[ChannelResponse], RemoteChannelsDataSourceError> { promise in
            Task {
                do {
                    let channelResponses: [ChannelResponse] = try await self.client
                        .from("channel")
                        .select()
                        .in("id", values: memberShip.map { $0.channelID })
                        .execute()
                        .value
                    
                    guard !channelResponses.isEmpty else {
                       return promise(.failure(.noItems))
                    }
                    
                    promise(.success(channelResponses))
                    
                } catch let urlError as URLError {
                    promise(.failure(.networkError(urlError)))
                } catch let postgRestError as PostgrestError {
                    promise(.failure(.postgRestError(postgRestError)))
                } catch let httpError as HTTPError {
                    promise(.failure(.serverError(httpError)))
                }  catch let decodingError as  DecodingError {
                    promise(.failure(.decodingError(decodingError)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
