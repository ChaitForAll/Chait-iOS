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
        let onReceiveChatHistories: AnyPublisher<[UUID], Never>
    }
    
    // MARK: Property(s)
    
    var userMessageText: String = ""
    
    private var chatMessagesDictionary: [PersonalChatMessage.ID: PersonalChatMessage] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    private var historyItemsOffset: Int = .zero
    
    private let receivedNewMessage: PassthroughSubject<[PersonalChatMessage.ID], Never> = .init()
    private let receivedChatHistories: PassthroughSubject<[PersonalChatMessage.ID], Never> = .init()
    
    private let userID: UUID
    private let channelID: UUID
    private let historyBatchSize: Int
    private let sendMessageUseCase: SendMessageUseCase
    private let listenMessagesUseCase: ListenMessagesUseCase
    private let fetchChatHistoryUseCase: FetchChatHistoryUseCase
    
    init(
        userID: UUID,
        channelID: UUID,
        historyBatchSize: Int = 10,
        sendMessageUseCase: SendMessageUseCase,
        listenMessagesUseCase: ListenMessagesUseCase,
        fetchChatHistoryUseCase: FetchChatHistoryUseCase
    ) {
        self.userID = userID
        self.channelID = channelID
        self.historyBatchSize = historyBatchSize
        self.sendMessageUseCase = sendMessageUseCase
        self.listenMessagesUseCase = listenMessagesUseCase
        self.fetchChatHistoryUseCase = fetchChatHistoryUseCase
    }
    
    // MARK: Function(s)
    
    func bindOutput() -> Output {
        return Output(
            onReceiveNewMessages: receivedNewMessage.eraseToAnyPublisher(),
            onReceiveChatHistories: receivedChatHistories.eraseToAnyPublisher()
        )
    }
    
    func onViewDidLoad() {
        startListening()
        fetchChatHistories()
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
                    self?.receivedNewMessage.send(allReceivedMessages.map {$0.id })
                    allReceivedMessages.forEach {
                        self?.chatMessagesDictionary[$0.id] = $0
                    }
                }
            )
            .store(in: &cancelBag)
    }
    
    private func fetchChatHistories() {
        fetchChatHistoryUseCase
            .fetchHistory(
                channelID: channelID,
                messagesOffset: historyItemsOffset,
                maxItemsCount: historyBatchSize
            )
            .receive(on: DispatchQueue.main)
            .map { $0.toUI() }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] historyMessages in
                    print(historyMessages)
                    self?.historyItemsOffset += (self?.historyBatchSize ?? .zero) + 1
                    historyMessages.forEach { self?.chatMessagesDictionary[$0.id] = $0 }
                    self?.receivedChatHistories.send(historyMessages.reversed().map { $0.id })
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
