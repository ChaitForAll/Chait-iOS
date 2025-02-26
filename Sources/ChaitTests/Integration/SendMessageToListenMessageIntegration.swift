//
//  SendMessageToListenMessageIntegration.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation
import Combine
import XCTest

final class SendMessageToListenMessageIntegration: XCTestCase {
    
    func test_SendingSingleMessage_ListenerReceivesSameMessageSuccessfully() {
        
        var cancelBag: Set<AnyCancellable> = .init()
        let mockRemoteMessages = MockRemoteMessagesDataSource()
        let chatRepository = DefaultChatRepository(remoteChatMessages: mockRemoteMessages)
        let sendMessageUseCase = DefaultSendMessageUseCase(repository: chatRepository)
        let listenMessagesUseCase = DefaultListenMessagesUseCase(chatRepository: chatRepository)
        
        // Arrange
        
        let messageTextToSend: String = "Test Message"
        let messageSenderID: UUID = .init()
        let messageChannelDestinationID: UUID = .init()
        
        let expectSendMessageSucceed = XCTestExpectation(description: "Sending succeed")
        let expectReceivingMessage = XCTestExpectation(description: "Listener received message")
        expectReceivingMessage.expectedFulfillmentCount = 1
        
        var receivedMessage: Message?
        
        listenMessagesUseCase
            .startListening(channelID: messageChannelDestinationID)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { messages in
                    expectReceivingMessage.fulfill()
                    receivedMessage = messages.first
                }
            )
            .store(in: &cancelBag)
        
        // Act
        
        sendMessageUseCase
            .sendMessage(
                text: messageTextToSend,
                senderID: messageSenderID, 
                channelID: messageChannelDestinationID
            )
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    expectSendMessageSucceed.fulfill()
                }
            )
            .store(in: &cancelBag)
        
        mockRemoteMessages.simulateSendMessagesSuccess()
        
        // Assert
        
        wait(for: [expectSendMessageSucceed, expectReceivingMessage], timeout: 1.0)
        
        guard let receivedMessage else {
            return XCTFail("No message was received")
        }
        
        XCTAssertEqual(messageTextToSend, receivedMessage.text)
        XCTAssertEqual(messageSenderID, receivedMessage.senderID)
        XCTAssertEqual(messageChannelDestinationID, receivedMessage.channelID)
    }
}

