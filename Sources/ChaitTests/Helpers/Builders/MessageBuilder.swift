//
//  MessageBuilder.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation

final class MessagesBuilder {
    
    private var text: String = "Message Text"
    private var messageID: UUID = .init()
    private var senderID: UUID = .init()
    private var channelID: UUID = .init()
    private var createdAt: Date = .now
    
    func withText(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    func withSenderID(_ identifier: UUID) -> Self {
        self.senderID = identifier
        return self
    }
    
    func withChannelID(_ identifier: UUID) -> Self {
        self.channelID = identifier
        return self
    }
    
    func withCreatedAt(_ createdAt: Date) -> Self {
        self.createdAt = createdAt
        return self
    }
    
    func build() -> Message {
        return Message(
            text: text,
            messageID: messageID,
            senderID: senderID,
            channelID: channelID,
            createdAt: createdAt
        )
    }
    
    func buildExactly(_ count: Int) -> [Message] {
        return (0..<count).map {
            Message(
                text: text + "\($0)",
                messageID: messageID,
                senderID: senderID,
                channelID: channelID,
                createdAt: createdAt
            )
        }
    }
}
