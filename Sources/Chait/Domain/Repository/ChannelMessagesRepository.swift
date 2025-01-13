//
//  ChannelMessagesRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

protocol MessagesRepository {
    var channelID: UUID { get }
    func create(_ newMessage: NewUserMessage) -> AnyPublisher<UserMessage, MessageError>
}
