//
//  ListenMessagesUseCaseTeest.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Combine
import XCTest

final class ListenMessagesTests: XCTestCase {
    
    private var sut: ListenMessagesUseCase!
    
    private let mockChatRepository: MockChatRepository = .init()
    private var cancelBag: Set<AnyCancellable> = .init()
    
    override func setUp() {
        self.sut = DefaultListenMessagesUseCase(chatRepository: mockChatRepository)
    }
    
    override func tearDown() {
        cancelBag.removeAll()
        self.sut = nil
    }
    
    func test_ListenMessagesReceivesFiveMessages() {
        
        // Arrange
        
        let expectedMessagesCount = 5
        let expectation = XCTestExpectation(description: "Message received")
        expectation.expectedFulfillmentCount = expectedMessagesCount
        
        let expectedMessages: [Message] = (0..<expectedMessagesCount).map {
            return Message(
                text: "Test Message \($0)",
                messageID: UUID(),
                senderID: UUID(),
                channelID: UUID(),
                createdAt: Date.now
            )
        }
        
        // Act
        
        var receivedMessages: [Message] = []
        
        sut
            .startListening(channelID: UUID())
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { messages in
                    receivedMessages.append(contentsOf: messages)
                    expectation.fulfill()
                }
            )
            .store(in: &cancelBag)
        
        expectedMessages.forEach { message in
            mockChatRepository.sendMessages(message)
        }
        
        // Assert
        
        wait(for: [expectation], timeout: 1.0)
        
        for (received, expected) in zip(receivedMessages, expectedMessages) {
            XCTAssertEqual(received.text, expected.text)
            XCTAssertEqual(received.senderID, expected.senderID)
            XCTAssertEqual(received.messageID, expected.messageID)
            XCTAssertEqual(received.channelID, expected.channelID)
            XCTAssertEqual(received.createdAt, expected.createdAt)
        }
    }
}
