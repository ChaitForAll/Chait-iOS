//
//  PersonalChatViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class PersonalChatViewModel {
    
    struct Output {
        let onReceiveNewMessages: AnyPublisher<[UUID], Never>
    }
    
    // MARK: Property(s)
    
    var userMessageText: String = ""
    
    private var receivedMessagesSubject: PassthroughSubject<[PersonalChatMessage.ID], Never> = .init()
    private var chatMessagesDictionary: [PersonalChatMessage.ID: PersonalChatMessage] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let userID: UUID
    private let channelID: UUID
    private let sendMessageUseCase: SendMessageUseCase
    private let listenMessagesUseCase: ListenMessagesUseCase
    
    init(
        userID: UUID = UUID(uuidString: "e22ffdc4-dddf-47cc-99e6-82cd56c7d415")!,
        channelID: UUID,
        sendMessageUseCase: SendMessageUseCase, 
        listenMessagesUseCase: ListenMessagesUseCase
    ) {
        self.userID = userID
        self.channelID = channelID
        self.sendMessageUseCase = sendMessageUseCase
        self.listenMessagesUseCase = listenMessagesUseCase
    }
    
    // MARK: Function(s)
    
    func bindOutput() -> Output {
        return Output(onReceiveNewMessages: receivedMessagesSubject.eraseToAnyPublisher())
    }
    
    func onViewDidLoad() {
        startListening()
    }
    
    func onSendMessage() {
        sendMessageUseCase
            .sendMessage(text: userMessageText, senderID: userID, channelID: channelID)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancelBag)
        userMessageText.removeAll()
    }
    
    func message(for identifier: UUID) -> PersonalChatMessage? {
        return chatMessagesDictionary[identifier]
    }
    
    // MARK: Private Function(s)
    
    private func startListening() {
        listenMessagesUseCase
            .startListening(channelID: channelID)
            .receive(on: DispatchQueue.main)
            .map { $0.toUI() }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] allReceivedMessages in
                    self?.receivedMessagesSubject.send(allReceivedMessages.map {$0.id })
                    allReceivedMessages.forEach {
                        self?.chatMessagesDictionary[$0.id] = $0
                    }
                }
            )
            .store(in: &cancelBag)
    }
}

private extension Array where Element == Message {
    func toUI() -> [PersonalChatMessage] {
        self.map { message in
            PersonalChatMessage(
                id: message.messageID,
                text: message.text,
                senderID: message.senderID,
                createdAt: message.createdAt
            )
        }
    }
}
