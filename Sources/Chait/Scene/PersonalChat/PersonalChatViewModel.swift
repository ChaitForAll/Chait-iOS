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
    
    private var isFetching: Bool = false
    private var chatMessagesDictionary: [PersonalChatMessage.ID: PersonalChatMessage] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    private var historyItemsOffset: Int = .zero
    
    private let receivedNewMessage: PassthroughSubject<[PersonalChatMessage.ID], Never> = .init()
    private let receivedChatHistories: PassthroughSubject<[PersonalChatMessage.ID], Never> = .init()
    
    private let userID: UUID
    private let conversationID: UUID
    private let historyBatchSize: Int
    private let conversationUseCase: ConversationUseCase
    
    init(
        userID: UUID,
        channelID: UUID,
        historyBatchSize: Int = 50,
        conversationUseCase: ConversationUseCase
    ) {
        self.userID = userID
        self.conversationID = channelID
        self.historyBatchSize = historyBatchSize
        self.conversationUseCase = conversationUseCase
    }
    
    // MARK: Function(s)
    
    func bindOutput() -> Output {
        return Output(
            onReceiveNewMessages: receivedNewMessage.eraseToAnyPublisher(),
            onReceiveChatHistories: receivedChatHistories.eraseToAnyPublisher()
        )
    }
    
    func onReachTop() {
        fetchChatHistories()
    }
    
    func onViewDidLoad() {
        startListening()
        fetchChatHistories()
    }
    
    func onSendMessage() {
        conversationUseCase
            .sendMessage(NewMessage(text: userMessageText, senderID: userID, conversationID: conversationID))
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancelBag)
        userMessageText.removeAll()
    }
    
    func message(for identifier: UUID) -> PersonalChatMessage? {
        return chatMessagesDictionary[identifier]
    }
    
    // MARK: Private Function(s)
    
    private func startListening() {
        conversationUseCase
            .startListeningMessages(conversationID)
            .receive(on: DispatchQueue.main)
            .map { messages in
                messages.map { message in
                    PersonalChatMessage(
                        id: message.messageID,
                        text: message.text,
                        senderID: message.senderID,
                        createdAt: message.createdAt
                    )
                }
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] allReceivedMessages in
                    allReceivedMessages.forEach {
                        self?.chatMessagesDictionary[$0.id] = $0
                    }
                    self?.receivedNewMessage.send(allReceivedMessages.map {$0.id })
                }
            )
            .store(in: &cancelBag)
    }
    
    private func fetchChatHistories() {
        guard !isFetching else {
            return
        }
        self.isFetching = true
        conversationUseCase
            .fetchHistory(
                conversationID,
                historyOffset: historyItemsOffset,
                maxItems: historyBatchSize
            )
            .receive(on: DispatchQueue.main)
            .map { messages in
                messages.map { message in
                    PersonalChatMessage(
                        id: message.messageID,
                        text: message.text,
                        senderID: message.senderID,
                        createdAt: message.createdAt
                    )
                }
            }
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isFetching = false
                },
                receiveValue: { [weak self] historyMessages in
                    self?.historyItemsOffset += (self?.historyBatchSize ?? .zero) + 1
                    historyMessages.forEach { self?.chatMessagesDictionary[$0.id] = $0 }
                    self?.receivedChatHistories.send(historyMessages.reversed().map { $0.id })
                }
            )
            .store(in: &cancelBag)
    }
}
