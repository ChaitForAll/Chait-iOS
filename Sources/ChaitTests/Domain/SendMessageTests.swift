//
//  SendMessageTests.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import XCTest
import Combine

final class SendMessageTests: XCTestCase {
    
    private var sut: SendMessageUseCase!
    private var mockChatRepository = MockChatRepository()
    private var cancelBag = Set<AnyCancellable>()
    
    override func setUp() {
        sut = DefaultSendMessageUseCase(repository: mockChatRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        mockChatRepository.injectedError = .none
    }
    
    func test_SendingMessageFailsOnNetworkError() {
        
        // Arrange
        
        mockChatRepository.injectedError = .networkError
        
        let expectation = XCTestExpectation(description: "Send failure received")
        
        // Act
        
        sut.sendMessage(text: "", senderID: UUID(), channelID: UUID())
            .sink { completion in
                if case .failure(let useCaseError) = completion, 
                    useCaseError == .sendMessageFailed
                {
                    expectation.fulfill()
                }
            } receiveValue: { _ in }
            .store(in: &cancelBag)
        
        // Assert

        wait(for: [expectation], timeout: 2)
    }
}
