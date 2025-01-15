//
//  DefaultChannelRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine
import Supabase

final class DefaultChannelRepository: ChannelRepository {
    
    // MARK: Property(s)
    
    private let service: SupaBasePlatform = .init()
    
    // MARK: Function(s)
    
    func fetchAllChannels() -> AnyPublisher<[Channel], ChannelRepositoryError> {
        return Future<[Channel], ChannelRepositoryError>() { promise in
            Task {
                do {
                    let channelResponses: [ChannelResponse] = try await self.service.client
                        .from("channel")
                        .select()
                        .execute()
                        .value
                    
                    if channelResponses.isEmpty {
                        promise(.failure(.noAvailableChannels))
                    }
                    
                    let channels = channelResponses.map { response in
                        Channel(
                            id: response.id,
                            title: response.title,
                            updatedAt: response.updateAt,
                            createdAt: response.createdAt
                        )
                    }
                    promise(.success(channels))
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func createNewChannel(_ newChannel: NewChannel) -> AnyPublisher<Void, ChannelRepositoryError> {
        return Future<Void, ChannelRepositoryError>() { promise in
            Task {
                do {
                    let newChannelToInsert = NewChannelRequest(title: newChannel.title)
                    let response = try await self.service.client
                        .from("channel")
                        .insert(newChannelToInsert)
                        .execute()
                        .response
                    
                    guard (200..<300).contains(response.statusCode) else {
                        promise(.failure(.serverError))
                        return
                    }
                    
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }.eraseToAnyPublisher()
    }
}
