//
//  ChatRepositoryTests.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation
import Combine
import XCTest

final class ChatRepositoryTests: XCTestCase {

    private var cancelBag: Set<AnyCancellable> = .init()
    
    func test_ListenMessagesReceivesFiveMessagesFromRemote() {
        
        // Arrange
        
        var receivedResponses: [Message] = []
        let expectedMessageResponses = MessageResponseBuilder().buildExactly(5)
        let expectation = XCTestExpectation(description: "Receive 5 remote responses")
        expectation.expectedFulfillmentCount = 5
        
        let succeedWithFiveMessages = StubRemoteMessages(messageResponses: expectedMessageResponses)
        let sut = DefaultChatRepository(remoteChatMessages: succeedWithFiveMessages)
        
        // Act
        
        sut.startListeningMessages(channelID: UUID())
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { responses in
                    expectation.fulfill()
                    receivedResponses.append(contentsOf: responses)
                }
            )
            .store(in: &cancelBag)
        
        succeedWithFiveMessages.fireToListener()
        
        // Assert
        
        wait(for: [expectation], timeout: 1.0)
        
        for (received, expected) in zip(receivedResponses, expectedMessageResponses) {
            XCTAssertEqual(received.text, expected.text)
            XCTAssertEqual(received.channelID, expected.channelID)
            XCTAssertEqual(received.senderID, expected.senderID)
            XCTAssertEqual(received.messageID, expected.messageID)
            XCTAssertEqual(received.createdAt, expected.createdAt)
        }
    }
    
    func test_ListenMessagesReceivesNetworkError() {
        
        // Arrange
        
        let expectation = XCTestExpectation(description: "Receives completion")
        let failWithNetworkError = StubRemoteMessages(failWith: .networkError)
        
        let sut = DefaultChatRepository(remoteChatMessages: failWithNetworkError)
        
        // Act
        
        sut.startListeningMessages(channelID: UUID())
            .sink(
                receiveCompletion: { completion in
                    expectation.fulfill()
                    switch completion {
                    case .finished:
                        XCTFail("Expected error but finished")
                    case .failure(let receivedError):
                        XCTAssertEqual(ListenMessagesError.networkError, receivedError)
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancelBag)
        
        // Assert
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_SendMessageReceivesVoidOnSuccess() {
        
        // Arrange
        
        let expectation = XCTestExpectation(description: "Receives Void on success sending")
        
        let succeedSendingMessage = StubRemoteMessages()
        let sut = DefaultChatRepository(remoteChatMessages: succeedSendingMessage)
        
        sut.sendMessage(text: "", senderID: .init(), channelID: .init())
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &cancelBag)
        
        // Assert
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_SendMessageFailSendingOnNetworkError() {
        
        // Arrange
        
        let expectation = XCTestExpectation(description: "Receives Completion")
        let failWithNetworkError = StubRemoteMessages(failWith: .networkError)
        let sut = DefaultChatRepository(remoteChatMessages: failWithNetworkError)
        
        // Act
        
        sut.sendMessage(text: "", senderID: UUID(), channelID: UUID())
            .sink(
                receiveCompletion: { completion in
                    expectation.fulfill()
                    switch completion {
                    case .finished:
                        XCTFail("Expected to fail but finished")
                    case .failure(let receivedError):
                        XCTAssertEqual(SendMessageError.sendMessageFailed, receivedError)
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancelBag)
        
        // Assert
        
        wait(for: [expectation], timeout: 1.0)
    }
}
