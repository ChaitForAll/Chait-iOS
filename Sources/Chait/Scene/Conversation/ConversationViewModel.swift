//
//  ConversationViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class ConversationViewModel {
    
    // MARK: Type(s)
    
    private enum SectionType: CaseIterable {
        case messageList
    }
    
    private typealias Section<Item: Identifiable> = ListSection<SectionType, Item>
    
    enum ViewAction {
        case appendItems(identifiers: [UUID])
        case insertItemsAtTop(identifiers: [UUID])
        case createSections(identifiers: [UUID])
    }
    
    // MARK: Property(s)
    
    var userMessageText: String = ""
    var viewAction: AnyPublisher<ViewAction, Never> {
        return viewActionSubject.eraseToAnyPublisher()
    }
    
    private var isFetching: Bool = false
    private var historyItemsOffset: Int = .zero
    private var cancelBag: Set<AnyCancellable> = []
    
    private let messageListSection = Section<ConversationMessageViewModel>(sectionType: .messageList)
    private let viewActionSubject: PassthroughSubject<ViewAction, Never> = .init()
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
    
    func onViewDidLoad() {
        viewActionSubject.send(.createSections(identifiers: [messageListSection.id]))
        startListening()
        fetchChatHistories()
    }
    
    func onReachTop() {
        fetchChatHistories()
    }
    
    func onSendMessage() {
        conversationUseCase
            .sendMessage(NewMessage(text: userMessageText, senderID: userID, conversationID: conversationID))
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancelBag)
        userMessageText.removeAll()
    }
    
    func message(for identifier: UUID) -> ConversationMessageViewModel? {
        return messageListSection.item(for: identifier)
    }
    
    // MARK: Private Function(s)
    
    private func startListening() {
        conversationUseCase
            .startListeningMessages(conversationID)
            .replaceError(with: [])
            .map { $0.map { ConversationMessageViewModel(message: $0) }}
            .handleEvents(receiveOutput: { [weak self] viewModels in
                self?.messageListSection.insertItems(viewModels)
            })
            .map { ViewAction.appendItems(identifiers: $0.map(\.id)) }
            .sink(receiveValue: { [weak self] appendItemsAction in
                self?.viewActionSubject.send(appendItemsAction)
            })
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
            .map { $0.map { ConversationMessageViewModel(message: $0)} }
            .handleEvents(
                receiveOutput: { [weak self] viewModels in
                    self?.messageListSection.insertItems(viewModels)
                    self?.historyItemsOffset += (self?.historyBatchSize ?? .zero) + 1
                },
                receiveCompletion: { [weak self] _ in
                    self?.isFetching = false
                }
            )
            .replaceError(with: [])
            .filter { !$0.isEmpty }
            .map { ViewAction.insertItemsAtTop(identifiers: $0.map(\.id))}
            .sink(receiveValue: { [weak self] viewAction in
                self?.viewActionSubject.send(viewAction)
            })
            .store(in: &cancelBag)
    }
}
