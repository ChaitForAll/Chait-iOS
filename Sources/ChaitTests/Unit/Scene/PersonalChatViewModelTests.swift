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
        
        let fakeChannelID = UUID()
        let fakeListenMessagesUseCase = StubListenMessageReceiveMessages()
        
        let sut = PersonalChatViewModel(
            channelID: fakeChannelID,
            sendMessageUseCase: StubSendMessageSucceed(),
            listenMessagesUseCase: fakeListenMessagesUseCase
        )
        
        // Act
        
        sut.userMessageText = "User Input Text"
        sut.onSendMessage()
        
        // Assert
        
        XCTAssertTrue(sut.userMessageText.isEmpty)
    }
    
    func test_UpdatesMessagesOnListenerReceiveMessages() {
        
        // Arrange
        
        let fakeChannelID = UUID()
        let fakeSendMessagesUseCase = StubSendMessageSucceed()
        
        let expectedMessages = (0..<5).map {
            return Message(
                text: "Test Message \($0)",
                messageID: UUID(),
                senderID: UUID(),
                channelID: UUID(),
                createdAt: Date.now
            )
        }
        
        let sut = PersonalChatViewModel(
            channelID: fakeChannelID,
            sendMessageUseCase: fakeSendMessagesUseCase,
            listenMessagesUseCase: StubListenMessageReceiveMessages(
                messages: expectedMessages
            )
        )
        
        let expectation = XCTestExpectation(description: "receives messages 5 times")
        expectation.expectedFulfillmentCount = 5
        
        // Act
        
        var receivedMessages: [String] = []
        
        sut.startListening()
        
        sut.messages.publisher
            .sink { message in
                receivedMessages.append(message)
                expectation.fulfill()
                print(message)
            }
            .store(in: &cancelBag)
        
        // Assert
        
        wait(for: [expectation], timeout: 1.0)
        
        for (received, expected) in zip(expectedMessages, receivedMessages) {
            XCTAssertEqual(received.text, expected)
        }
    }
}
