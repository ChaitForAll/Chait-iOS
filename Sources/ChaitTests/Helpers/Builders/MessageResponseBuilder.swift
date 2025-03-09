//
//  MessageResponseBuilder.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation

final class MessageResponseBuilder {
    
    private var text: String = "Response Message Text"
    private var messageID: UUID = .init()
    private var senderID: UUID = .init()
    private var channelID: UUID = .init()
    private var createdAt: Date = .now

    // MARK: Function(s)
    
    func withText(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    func withMessageID(_ messageID: UUID) -> Self {
        self.messageID = messageID
        return self
    }
    
    func withSenderID(_ senderID: UUID) -> Self {
        self.senderID = senderID
        return self
    }
    
    func withChannelID(_ channelID: UUID) -> Self {
        self.channelID = channelID
        return self
    }
    
    func withCreatedAt(_ createdAt: Date) -> Self {
        self.createdAt = createdAt
        return self
    }
    
    func build() -> MessageResponse {
        return MessageResponse(
            text: text,
            messageID: messageID,
            senderID: senderID,
            channelID: channelID,
            createdAt: createdAt
        )
    }
    
    func buildExactly(_ count: Int) -> [MessageResponse] {
        return (0..<count).map { _ in
            MessageResponse(
                text: text,
                messageID: messageID,
                senderID: senderID,
                channelID: channelID,
                createdAt: createdAt
            )
        }
    }
}
