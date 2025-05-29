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
    
    private var isFetchEnabled: Bool = true
    private var historyItemsOffset: Int = .zero
    private var cancelBag: Set<AnyCancellable> = []
    private var messages: [Message] = []
    
    private let messageListSection = Section<ConversationMessageViewModel>(sectionType: .messageList)
    private let viewActionSubject: PassthroughSubject<ViewAction, Never> = .init()
    private let conversationID: UUID
    private let historyBatchSize: Int
    private let conversationUseCase: ConversationUseCase
    private let sendMessageUseCase: SendMessageUseCase
    private let fetchConversationHistoryUseCase: FetchConversationHistoryUseCase
    
    init(
        channelID: UUID,
        historyBatchSize: Int = 50,
        conversationUseCase: ConversationUseCase,
        sendMessageUseCase: SendMessageUseCase,
        fetchConversationHistoryUseCase: FetchConversationHistoryUseCase
    ) {

        self.conversationID = channelID
        self.historyBatchSize = historyBatchSize
        self.conversationUseCase = conversationUseCase
        self.sendMessageUseCase = sendMessageUseCase
        self.fetchConversationHistoryUseCase = fetchConversationHistoryUseCase
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        viewActionSubject.send(.createSections(identifiers: [messageListSection.id]))
        startListening()
        Task {
            await fetchChatHistories()
        }
    }
    
    func onReachTop() {
        guard isFetchEnabled else { return }
        isFetchEnabled = false
        Task {
            isFetchEnabled =  await fetchChatHistories()
        }
    }
    
    func onSendMessage() {
        let messageText = userMessageText
        let conversationID = conversationID
        Task.detached(priority: .background) {
            let sendMessageCommand = SendMessageCommand(
                message: messageText,
                conversationIdentifier: conversationID
            )
            _ = await self.sendMessageUseCase.execute(sendMessageCommand)
            self.userMessageText.removeAll()
        }
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
    
    private func fetchChatHistories() async -> Bool {
        
        var messageQuery: MessageQuery = .mostRecent
        
        if let lastMessage = messages.first {
            print(lastMessage)
            messageQuery = .before(lastMessage)
        }
        
        let result = await fetchConversationHistoryUseCase
            .execute(FetchConversationHistoryCommand(
                conversationIdentifier: conversationID,
                query: messageQuery,
                limit: 40
            ))
        
        switch result {
        case .success(let historyItems):
            var fetchedHistoryMessages: [Message] = []
            for historyItem in historyItems {
                switch historyItem {
                case .message(let message):
                    fetchedHistoryMessages.append(message)
                }
            }
            fetchedHistoryMessages = fetchedHistoryMessages.reversed()
            messages.insert(contentsOf: fetchedHistoryMessages, at: .zero)
            messageListSection.insertItems(fetchedHistoryMessages.map { ConversationMessageViewModel(message: $0)})
            viewActionSubject.send(.insertItemsAtTop(identifiers: fetchedHistoryMessages.map(\.messageID)))
        case .failure(let failure):
            print(failure)
        }
        
        return true
    }
}
