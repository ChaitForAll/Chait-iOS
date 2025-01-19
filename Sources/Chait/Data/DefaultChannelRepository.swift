//
//  DefaultChannelRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine
import Supabase

final class DefaultChannelRepository: ChannelRepository {
    
    // MARK: Property(s)
    
    private let channelUpdateSubject = PassthroughSubject<ChannelUpdate, ChannelRepositoryError>()
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
    
    func listenChannelUpdates() -> AnyPublisher<ChannelUpdate, ChannelRepositoryError> {
        Task {
            let channel = self.service.client.realtimeV2.channel("channelUpdates")
            let tableChanges = channel.postgresChange(AnyAction.self, table: "channel")
            
            await channel.subscribe()
            
            do {
                for await change in tableChanges {
                    
                    let updateState: ChannelUpdate.UpdateState
                    let updatedChannelResponse: ChannelResponse
                    
                    switch change {
                    case .insert(let insertAction):
                        updateState = .inserted
                        updatedChannelResponse = try insertAction.decodeRecord(
                            as: ChannelResponse.self,
                            decoder: .defaultStorageDecoder
                        )
                    case .update(let updateAction):
                        updateState = .updated
                        updatedChannelResponse = try updateAction.decodeRecord(
                            as: ChannelResponse.self,
                            decoder: .defaultStorageDecoder
                        )
                    case .delete(let deleteAction):
                        updateState = .deleted
                        let deleteResponse = try deleteAction.decodeOldRecord(
                            as: DeleteChannelResponse.self,
                            decoder: .defaultStorageDecoder
                        )
                        updatedChannelResponse = ChannelResponse(
                            id: deleteResponse.id,
                            title: "",
                            createdAt: .distantPast,
                            updateAt: .distantPast
                        )
                    }
                    
                    let channelUpdate = ChannelUpdate(
                        updatedChannel: Channel(
                            id: updatedChannelResponse.id,
                            title: updatedChannelResponse.title,
                            updatedAt: updatedChannelResponse.updateAt,
                            createdAt: updatedChannelResponse.createdAt
                        ),
                        channelUpdateState: updateState
                    )
                    channelUpdateSubject.send(channelUpdate)
                }
            } catch {
                channelUpdateSubject.send(completion: .failure(.unknown))
            }
        }
        
        return channelUpdateSubject.eraseToAnyPublisher()
    }
}
