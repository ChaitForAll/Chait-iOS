//
//  PersonalChatViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class PersonalChatViewModel {
    
    // MARK: Property(s)
    
    var userMessageText: String = ""
    
    private var receivedMessagesSubject: PassthroughSubject<PersonalChatMessage.ID, Never> = .init()
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
    
    func onSendMessage() {
        sendMessageUseCase
            .sendMessage(text: userMessageText, senderID: userID, channelID: channelID)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancelBag)
        userMessageText.removeAll()
    }
    
    func startListening() -> AnyPublisher<UUID, Never> {
        listenMessagesUseCase
            .startListening(channelID: channelID)
            .receive(on: DispatchQueue.main)
            .map { $0.map { self.toPersonalChatMessage($0).id } }
            .sink(
                receiveCompletion: { completion in
                    print(completion)
                },
                receiveValue: { [weak self] allReceivedIdentifiers in
                    allReceivedIdentifiers.forEach { messageIdentifier in
                        self?.receivedMessagesSubject.send(messageIdentifier)
                    }
                }
            )
            .store(in: &cancelBag)
        return receivedMessagesSubject.eraseToAnyPublisher()
    }
    
    func message(for identifier: UUID) -> PersonalChatMessage? {
        return chatMessagesDictionary[identifier]
    }
    
    // MARK: Private Function(s)
    
    private func toPersonalChatMessage(_ message: Message) -> PersonalChatMessage {
        let personalChatMessage = PersonalChatMessage(
            id: message.messageID,
            text: message.text,
            senderID: message.senderID,
            createdAt: message.createdAt
        )
        self.chatMessagesDictionary[personalChatMessage.id] = personalChatMessage
        return personalChatMessage
    }
}
