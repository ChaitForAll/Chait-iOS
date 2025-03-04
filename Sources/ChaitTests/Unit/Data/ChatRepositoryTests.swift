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
    
    private var sut: ChatRepository!
    private var cancelBag: Set<AnyCancellable> = .init()
    private let mockRemoteDataSource = MockRemoteMessagesDataSource()
    
    override func setUp() {
        self.sut = DefaultChatRepository(remoteChatMessages: mockRemoteDataSource)
    }
    
    func test_ListenMessagesReceivesFiveMessagesFromRemote() {
        
        // Arrange
        
        let expectedResponseCount: Int = 5
        let expectation = XCTestExpectation(description: "Receive 5 remote responses")
        expectation.expectedFulfillmentCount = expectedResponseCount
        
        let expectedMessageResponses: [MessageResponse] = generateResponses(count: expectedResponseCount)
        
        // Act
        
        var receivedResponses: [Message] = []
        
        sut
            .startListeningMessages(channelID: UUID())
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { responses in
                    expectation.fulfill()
                    print(responses)
                    receivedResponses.append(contentsOf: responses)
                }
            )
            .store(in: &cancelBag)
        
        expectedMessageResponses.forEach { expectedResponse in
            mockRemoteDataSource.simulateReceiveMessageResponses([expectedResponse])
        }
        
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
        
        let expectation = XCTestExpectation(description: "Expect to fail with network error")
        
        // Act
        
        sut
            .startListeningMessages(channelID: UUID())
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let remoteError) = completion, remoteError == .networkError {
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancelBag)
        
        mockRemoteDataSource.simulateReceiveErrorListeningMessages(.networkError)
        
        // Asssert
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_SendMessageReceivesVoidOnSuccess() {
        
        // Arrange
        
        let expectation = XCTestExpectation(description: "Receives Void on success sending")
        
        sut
            .sendMessage(text: "", senderID: UUID(), channelID: UUID())
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    expectation.fulfill()
                }
            )
            .store(in: &cancelBag)
        
        // Act
        
        mockRemoteDataSource.simulateSendMessagesSuccess()
        
        // Assert
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_SendMessageFailSendingOnNetworkError() {
        
        // Arrange
        
        let expectation = XCTestExpectation(description: "Send message fails on network error")
        
        sut
            .sendMessage(text: "", senderID: UUID(), channelID: UUID())
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let sendMessageError) = completion, sendMessageError == .sendMessageFailed {
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancelBag)
        
        // Act
        
        mockRemoteDataSource.simulateSendMessageError(.networkError)
        
        // Assert
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func generateResponses(count: Int) -> [MessageResponse] {
        return (0..<count).map {
            return MessageResponse(
                text: "Test Response \($0)",
                messageID: UUID(),
                senderID: UUID(),
                channelID: UUID(),
                createdAt: Date.now
            )
        }
    }
}
