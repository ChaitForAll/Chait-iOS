//
//  FetchFriendListUseCaseTest.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import XCTest
import Combine
import Foundation

final class FetchFriendListUseCaseTest: XCTestCase {
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    // MARK: Cases
    
    func test_fetchFriendsListFailWithUnknownError() {
        
        let expectedError = FetchFriendsListError.unknown
        let stubFriendRepository = StubFriendRepository().withFailure(expectedError)
        let sut = DefaultFetchFriendsListUseCase(repository: stubFriendRepository)
        
        let expectation = XCTestExpectation(description: "ads")
        
        sut.fetchFriendList(userID: UUID())
            .sink { completion in
                expectation.fulfill()
                switch completion {
                case .finished:
                    XCTFail("Expected to fail but finished.")
                case .failure(let failedError):
                    XCTAssertEqual(failedError, expectedError)
                }
            } receiveValue: { friendList in
                XCTFail("Expected to fail but received friends list. \(friendList)")
            }
            .store(in: &cancelBag)
        
        wait(for: [expectation], timeout: 2.0)
    }
}
