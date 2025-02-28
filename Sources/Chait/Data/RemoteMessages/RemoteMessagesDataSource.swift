//
//  RemoteMessagesDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum RemoteMessagesDataSourceError: Error {
    case networkError
}

protocol RemoteMessagesDataSource {
    func sendMessage(
        text: String,
        senderID: UUID,
        channelID: UUID
    ) -> AnyPublisher<Void, RemoteMessagesDataSourceError>
    
    func startListeningMessages(channelID: UUID) -> AnyPublisher<[MessageResponse], RemoteMessagesDataSourceError>
}
