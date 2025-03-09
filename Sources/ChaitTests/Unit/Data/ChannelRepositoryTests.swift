//
//  ChannelRepositoryTests.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


@testable import Chait
import Foundation
import Combine
import XCTest

final class ChannelRepositoryTests: XCTestCase {
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    override func tearDown() {
        self.cancelBag.removeAll()
    }
    
    func test_FetchChannelMembershipFailsWithNoChannels() {
        
        // Arrange
        
        let stubDataSource = StubRemoteChannelsDataSource(error: .noItems)
        let sut = DefaultChannelRepository(dataSource: stubDataSource)
        let receivedErrorExpectation = XCTestExpectation(description: "Receives completion")
        
        // Act
        
        sut.fetchChannels(userID: UUID())
            .sink(
                receiveCompletion: { completion in
                    receivedErrorExpectation.fulfill()
                    switch completion {
                    case .finished:
                        XCTFail("Expected to fail. But finished")
                    case .failure(let failure):
                        XCTAssertEqual(FetchChannelListUseCaseError.noChannels, failure)
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancelBag)
        
        // Assert
        
        wait(for: [receivedErrorExpectation], timeout: 1.0)
    }
}
