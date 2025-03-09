//
//  SendMessageTests.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import XCTest
import Combine

final class SendMessageTests: XCTestCase {
    
    private var cancelBag = Set<AnyCancellable>()
    
    override func tearDown() {
        cancelBag.removeAll()
    }
    
    func test_SendingMessageFailsOnNetworkError() {
        
        // Arrange
        
        let stubSendFails = StubChatRepository(failWithSendMessageError: .sendMessageFailed)
        let sut = DefaultSendMessageUseCase(repository: stubSendFails)
        
        let expectation = XCTestExpectation(description: "Send failure received")
        
        // Act
        
        sut.sendMessage(text: "", senderID: UUID(), channelID: UUID())
            .sink { completion in
                expectation.fulfill()
                switch completion {
                case .finished:
                    XCTFail("Expected to fail but finished.")
                case .failure(let error):
                    XCTAssertEqual(error, SendMessageError.sendMessageFailed)
                }
            } receiveValue: { _ in }
            .store(in: &cancelBag)
        
        // Assert

        wait(for: [expectation], timeout: 2)
    }
}
