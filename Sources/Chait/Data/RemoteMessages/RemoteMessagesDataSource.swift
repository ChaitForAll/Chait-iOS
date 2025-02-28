//
//  RemoteMessagesDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine
import Supabase

enum RemoteMessagesDataSourceError: Error {
    case networkError
    case serverError
    case unknownError(_ error: Error)
}

protocol RemoteMessagesDataSource {
    func sendMessage(
        text: String,
        senderID: UUID,
        channelID: UUID
    ) -> AnyPublisher<Void, RemoteMessagesDataSourceError>
    
    func startListeningMessages(channelID: UUID) -> AnyPublisher<[MessageResponse], RemoteMessagesDataSourceError>
}

final class DefaultRemoteMessagesDataSource: RemoteMessagesDataSource {
    
    // MARK: Property(s)
    
    private var listeningTask: Task<Void, Never>?
    
    private let messageListenSubject: PassthroughSubject<[MessageResponse], RemoteMessagesDataSourceError> = .init()
    
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    // MARK: Function(s)
    
    func sendMessage(
        text: String,
        senderID: UUID,
        channelID: UUID
    ) -> AnyPublisher<Void, RemoteMessagesDataSourceError> {
        return Future<Void, RemoteMessagesDataSourceError> { promise in
            Task {
                let newMessageRequest = NewMessageRequest(text: text, senderID: senderID, channelID: channelID)
                
                do {
                    let response = try await self.client
                        .from("messages")
                        .insert(newMessageRequest)
                        .execute()
                        .response
                    
                    response.statusCode == 201 ? promise(.success(())) : promise(.failure(.serverError))
                } catch {
                    promise(.failure(.unknownError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func startListeningMessages(
        channelID: UUID
    ) -> AnyPublisher<[MessageResponse], RemoteMessagesDataSourceError> {
        
        let channel = client
            .realtimeV2
            .channel(channelID.uuidString)
        
        let insertionListener = channel.postgresChange(InsertAction.self, table: "messages")
        
        let listenTask = Task {
            
            await channel.subscribe()
            
            for await insertion in insertionListener {
                do {
                    let messageResponse = try insertion.decodeRecord(
                        as: MessageResponse.self,
                        decoder: .defaultStorageDecoder
                    )
                    messageListenSubject.send([messageResponse])
                } catch {
                    messageListenSubject.send(completion: .failure(.unknownError(error)))
                }
            }
        }
        
        self.listeningTask = listenTask
        
        return messageListenSubject
            .handleEvents(receiveCancel: { listenTask.cancel() })
            .eraseToAnyPublisher()
    }
}
