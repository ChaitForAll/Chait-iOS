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
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    override func tearDown() {
        cancelBag.removeAll()
    }
    
    func test_SendingSingleMessage_ListenerReceivesSameMessageSuccessfully() {
        
        let expectedMessage = MessageResponseBuilder().build()
        let stubRemoteMessages = StubRemoteMessages(messageResponses: [expectedMessage])
        let chatRepository = DefaultChatRepository(remoteChatMessages: stubRemoteMessages)
        let sendMessageUseCase = DefaultSendMessageUseCase(repository: chatRepository)
        let listenMessagesUseCase = DefaultListenMessagesUseCase(chatRepository: chatRepository)
        
        // Arrange
        
        let expectSendMessageSucceed = XCTestExpectation(description: "Sending succeed")
        let expectReceivingMessage = XCTestExpectation(description: "Listener received message")
        expectReceivingMessage.expectedFulfillmentCount = 1
        
        var receivedMessage: Message?
        
        listenMessagesUseCase
            .startListening(channelID: .init())
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { messages in
                    expectReceivingMessage.fulfill()
                    receivedMessage = messages.first
                }
            )
            .store(in: &cancelBag)
        
        // Act
        
        stubRemoteMessages.fireToListener()
        
        sendMessageUseCase
            .sendMessage(
                text: expectedMessage.text,
                senderID: expectedMessage.senderID,
                channelID: expectedMessage.channelID
            )
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    expectSendMessageSucceed.fulfill()
                }
            )
            .store(in: &cancelBag)
        
        // Assert
        
        wait(for: [expectSendMessageSucceed, expectReceivingMessage], timeout: 1.0)
        
        guard let receivedMessage else {
            return XCTFail("No message was received")
        }
        
        XCTAssertEqual(expectedMessage.text, receivedMessage.text)
        XCTAssertEqual(expectedMessage.senderID, receivedMessage.senderID)
        XCTAssertEqual(expectedMessage.channelID, receivedMessage.channelID)
    }
}

