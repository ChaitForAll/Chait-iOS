//
//  PersonalChatViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class PersonalChatViewModel {
    
    // MARK: Property(s)
    
    @Published var messages: [String] = []
    var userMessageText: String = ""
    
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let channelID: UUID
    private let sendMessageUseCase: SendMessageUseCase
    private let listenMessagesUseCase: ListenMessagesUseCase
    
    init(
        channelID: UUID,
        sendMessageUseCase: SendMessageUseCase, 
        listenMessagesUseCase: ListenMessagesUseCase
    ) {
        self.channelID = channelID
        self.sendMessageUseCase = sendMessageUseCase
        self.listenMessagesUseCase = listenMessagesUseCase
    }
    
    // MARK: Function(s)
    
    func onSendMessage() {
        sendMessageUseCase
            .sendMessage(text: userMessageText, senderID: UUID(), channelID: channelID)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in }
            )
            .store(in: &cancelBag)
    }
    
    func startListening() {
        listenMessagesUseCase
            .startListening(channelID: channelID)
            .map { messages in
                messages.map { $0.text } }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self ] receivedMessages in
                    self?.messages.append(contentsOf: receivedMessages)
                }
            )
            .store(in: &cancelBag)
    }
}
