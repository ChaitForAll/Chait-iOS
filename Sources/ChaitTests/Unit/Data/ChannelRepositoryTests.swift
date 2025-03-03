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
        
        let userID = UUID()
        let expectedMemberships = (0..<5).map { _ in
            ChannelMembershipResponse(userID: userID, channelID: UUID())
        }
        let stubDataSource = StubRemoteChannelDataSourceSucceed(memberShipResponses: expectedMemberships)
        let sut = DefaultChannelRepository(dataSource: stubDataSource)
        
        // Act
        
        let receivedErrorExpectation = XCTestExpectation(description: "Received no channels error")
        sut
            .fetchChannels(userID: userID)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedErrorExpectation.fulfill()
                        XCTAssertEqual(error, .noChannels)
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancelBag)
        
        // Assert
        
        wait(for: [receivedErrorExpectation], timeout: 1.0)
    }
}
