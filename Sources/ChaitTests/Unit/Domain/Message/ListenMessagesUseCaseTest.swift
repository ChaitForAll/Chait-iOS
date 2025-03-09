//
//  ListenMessagesUseCaseTeest.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Combine
import XCTest

final class ListenMessagesTests: XCTestCase {
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    override func tearDown() {
        cancelBag.removeAll()
    }
    
    func test_ListenMessagesReceivesFiveMessages() {
        
        // Arrange
        
        let expectedMessagesCount = 5
        let expectation = XCTestExpectation(description: "Message received")
        expectation.expectedFulfillmentCount = expectedMessagesCount
        
        let expectedMessages = MessagesBuilder().buildExactly(5)
        let stubSucceedWithFiveMessages = StubChatRepository(succeedWith: expectedMessages)
        let sut = DefaultListenMessagesUseCase(chatRepository: stubSucceedWithFiveMessages)
        
        // Act
        
        var receivedMessages: [Message] = []
        
        sut.startListening(channelID: UUID())
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished: return
                    case .failure(let error):
                        XCTFail("expected to finish but failed \(error)")
                    }
                },
                receiveValue: { messages in
                    expectation.fulfill()
                    receivedMessages.append(contentsOf: messages)
                }
            )
            .store(in: &cancelBag)
        
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
