//
//  FetchChannelListUseCaseTest.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


@testable import Chait
import Combine
import XCTest

final class FetchChannelListUseCaseTest: XCTestCase {
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    override func tearDown() {
        cancelBag.removeAll()
    }
    
    func test_FetchChannelListSucceedWith5Channels() {
        
        // Arrange
        
        let fetchExpectation = XCTestExpectation(description: "Received channels")
        let expectedChannels = (0..<5).map {
            Channel(channelID: UUID(), title: "Test Channel Title \($0)")
        }
        let mockSuccess = StubFetchChannelListSuccess(channels: expectedChannels)
        let sut = DefaultFetchChannelListUseCase(repository: mockSuccess)
        
        // Act
        
        var receivedChannels: [Channel] = []
        
        sut.fetchChannels(UUID())
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { channels in
                    fetchExpectation.fulfill()
                    receivedChannels.append(contentsOf: channels)
                }
            )
            .store(in: &cancelBag)
        
        // Assert
        
        wait(for: [fetchExpectation], timeout: 2)
        
        for (expected, received) in zip(expectedChannels, receivedChannels) {
            XCTAssertEqual(expected.channelID, received.channelID)
            XCTAssertEqual(expected.title, received.title)
        }
    }
    
    func test_FetchChannelFailsWithNoChannels() {
        
        // Arrange
        
        let expectedError: FetchChannelListUseCaseError = .noChannels
        let stubFetchFails = StubFetchChannelFails(error: expectedError)
        let sut = DefaultFetchChannelListUseCase(repository: stubFetchFails)
        let failExpectation = XCTestExpectation(description: "Fetch fails")
        
        // Act & Assert
        
        sut
            .fetchChannels(.init())
            .sink(
                receiveCompletion: { completion in
                    failExpectation.fulfill()
                    if case .failure(let receivedError) = completion {
                        XCTAssertEqual(receivedError, expectedError)
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancelBag)
    }
}
