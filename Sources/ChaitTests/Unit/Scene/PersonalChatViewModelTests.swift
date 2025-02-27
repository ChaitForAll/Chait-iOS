//
//  PersonalChatViewModelTests.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation
import XCTest

final class PersonalChatViewModelTests: XCTestCase {
    
    // MARK: Test(s)
    
    func test_ClearsUserMessageInputOnSendMessage() {
        
        //Arrange
        
        let fakeChannelID = UUID()
        let fakeListenMessagesUseCase = StubListenMessageReceiveMessages()
        
        let sut = PersonalChatViewModel(
            channelID: fakeChannelID,
            sendMessageUseCase: StubSendMessageSucceed(),
            listenMessagesUseCase: fakeListenMessagesUseCase
        )
        
        // Act
        
        sut.userMessageText = "User Input Text"
        sut.onSendMessage()
        
        // Assert
        
        XCTAssertTrue(sut.userMessageText.isEmpty)
    }
}
