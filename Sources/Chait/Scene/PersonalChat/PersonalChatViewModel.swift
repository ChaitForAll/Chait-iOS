//
//  PersonalChatViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class PersonalChatViewModel {
    
    var userMessageText: String = ""
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let channelID: UUID
    private let sendMessageUseCase: SendMessageUseCase
    
    init(channelID: UUID, sendMessageUseCase: SendMessageUseCase) {
        self.channelID = channelID
        self.sendMessageUseCase = sendMessageUseCase
    }
    
    func onSendMessage() {
        sendMessageUseCase
            .sendMessage(text: userMessageText, senderID: UUID(), channelID: channelID)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in }
            )
            .store(in: &cancelBag)
    }
}
