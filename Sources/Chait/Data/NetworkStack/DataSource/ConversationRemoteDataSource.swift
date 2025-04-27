//
//  ConversationRemoteDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation
import Combine
import Supabase

enum ConversationDatasourceError: Error {
    case unknown
    case endOfItems
}

protocol ConversationRemoteDataSource {
    func fetchConversations(
        _ conversationIdentifiers: [UUID]
    ) async throws -> [ConversationResponse]
    func insertNewMessage(_ request: NewMessageRequest) async throws -> MessageResponse
    func startListeningInsertions(
        _ conversationID: UUID
    ) -> AnyPublisher<[MessageResponse], ConversationDatasourceError>
    func readHistory(
        channelID: UUID,
        historyOffset: Int,
        maxItemsCount: Int
    ) -> AnyPublisher<[MessageResponse], ConversationDatasourceError>
}

final class DefaultConversationRemoteDataSource: ConversationRemoteDataSource {
    
    // MARK: Property(s)
    
    private var listeningTask: Task<Void, Never>?
    
    private let messageListenSubject: PassthroughSubject<[MessageResponse], ConversationDatasourceError> = .init()
    private let supabase: SupabaseClient
    
    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }
    
    // MARK: Function(s)
    
    func fetchConversations(
        _ conversationIdentifiers: [UUID]
    ) async throws -> [ConversationResponse] {
        return try await supabase
            .from("conversations")
            .select()
            .in("id", values: conversationIdentifiers)
            .execute()
            .decodeJSON()
    }
    
    func insertNewMessage(_ request: NewMessageRequest) async throws -> MessageResponse {
        try await supabase
            .from("messages")
            .insert(request)
            .execute()
            .decodeJSON()
    }
    
    func startListeningInsertions(
        _ conversationID: UUID
    ) -> AnyPublisher<[MessageResponse], ConversationDatasourceError> {
        let channel = supabase.realtimeV2.channel(conversationID.uuidString)
        let insertionListener = channel.postgresChange(InsertAction.self, table: "messages")
        let listenTask = Task {
            await channel.subscribe()
            
            for await insertion in insertionListener {
                if let messageResponse = try? insertion.decodeRecord(
                    as: MessageResponse.self,
                    decoder: .defaultStorageDecoder
                ) {
                    messageListenSubject.send([messageResponse])
                }
                messageListenSubject.send(completion: .failure(.unknown))
            }
        }
        
        self.listeningTask = listenTask
        
        return messageListenSubject
            .handleEvents(receiveCancel: { listenTask.cancel() })
            .eraseToAnyPublisher()
    }
    
    func readHistory(
        channelID: UUID,
        historyOffset: Int,
        maxItemsCount: Int
    ) -> AnyPublisher<[MessageResponse], ConversationDatasourceError> {
        return Future<[MessageResponse], ConversationDatasourceError> { promise in
            Task {
                do {
                    let historyResponses: [MessageResponse] = try await self.supabase
                        .from("messages")
                        .select()
                        .eq("conversation_id", value: channelID)
                        .order("created_at", ascending: false)
                        .range(from: historyOffset + 1, to: historyOffset + maxItemsCount)
                        .execute()
                        .value
                    
                    guard !historyResponses.isEmpty else {
                        return promise(.failure(.endOfItems))
                    }
                    
                    promise(.success(historyResponses))
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
