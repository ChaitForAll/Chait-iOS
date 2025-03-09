//
//  PersonalChatViewModelBuilder.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation

final class PersonalChatViewModelBuilder {
    
    // MARK: Property(s)
    
    private var fetchHistoriesUseCase: FetchChatHistoryUseCase = DummyFetchHistoriesUseCase()
    private var listenMessagesUseCase: ListenMessagesUseCase = DummyListenMessagesUseCase()
    private var sendMessageUseCase: SendMessageUseCase = DummySendMessageUseCase()
    private var maxChatHistoryCount: Int = .zero
    private var channelID: UUID = .init()
    private var userID: UUID = .init()
    
    // MARK: Function(s)
    
    func withListenMessageUseCase(_ useCase: ListenMessagesUseCase) -> Self {
        self.listenMessagesUseCase = useCase
        return self
    }
    
    func withFetchHistoryUseCase(_ useCase: FetchChatHistoryUseCase) -> Self {
        self.fetchHistoriesUseCase = useCase
        return self
    }
    
    func withSendMessageUseCase(_ useCase: SendMessageUseCase) -> Self {
        self.sendMessageUseCase = useCase
        return self
    }
    
    func withMaxHistoryCount(_ maxHistoryCount: Int) -> Self {
        self.maxChatHistoryCount = maxHistoryCount
        return self
    }
    
    func withChannelID(_ channelID: UUID) -> Self {
        self.channelID = channelID
        return self
    }
    
    func withUserID(_ userID: UUID) -> Self {
        self.userID = userID
        return self
    }
    
    func build() -> PersonalChatViewModel {
        return PersonalChatViewModel(
            maxChatHistoryCount: maxChatHistoryCount,
            userID: userID,
            channelID: channelID,
            sendMessageUseCase: sendMessageUseCase,
            listenMessagesUseCase: listenMessagesUseCase,
            fetchHistoryUseCase: fetchHistoriesUseCase
        )
    }
}
