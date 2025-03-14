//
//  PersonalChatViewModelTests.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation
import Combine
import XCTest

final class PersonalChatViewModelTests: XCTestCase {
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    // MARK: Test(s)
    
    func test_ClearsUserMessageInputOnSendMessage() {
        
        //Arrange
        
        let sendSucceed = StubSendMessageSucceed()
        
        let sut = PersonalChatViewModelBuilder()
            .withSendMessageUseCase(sendSucceed)
            .build()
        
        // Act
        
        sut.userMessageText = "User Input Text"
        sut.onSendMessage()
        
        // Assert
        
        XCTAssertTrue(sut.userMessageText.isEmpty)
    }
    
    func test_UpdatesMessagesOnListenerReceiveMessages() {
        
        // Arrange
        
        var receivedMessages: [PersonalChatMessage] = []
        let expectedMessages = MessagesBuilder().buildExactly(5)
        let stubListenMessagesSucceed = StubListenMessageReceiveMessages(messages: expectedMessages)
        let sut = PersonalChatViewModelBuilder()
            .withListenMessageUseCase(stubListenMessagesSucceed)
            .build()
        
        let sutOutput = sut
            .bindOutput()
            .onReceiveNewMessages
        
        let expectation = XCTestExpectation(description: "receives messages 5 times")
        expectation.expectedFulfillmentCount = 5
        
        // Act
        
        sut.onViewDidLoad()
        
        sutOutput
            .sink { messageIdentifiers in
                expectation.fulfill()
                messageIdentifiers.forEach { id in
                    if let message = sut.message(for: id) {
                        receivedMessages.append(message)
                    }
                }
            }
            .store(in: &cancelBag)
        
        stubListenMessagesSucceed.fire()
        
        // Assert
        
        wait(for: [expectation], timeout: 1.0)
        
        for (received, expected) in zip(expectedMessages, receivedMessages) {
            XCTAssertEqual(received.text, expected.text)
            XCTAssertEqual(received.senderID, expected.senderID)
            XCTAssertEqual(received.createdAt, expected.createdAt)
        }
    }
}
