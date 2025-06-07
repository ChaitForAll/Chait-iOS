//
//  ConversationViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class ConversationViewModel {
    
    enum MessageReceiveType {
        case history([UUID])
        case new(UUID)
    }
    
    // MARK: Property(s)
    
    @Published var userMessageText: String = ""
    var messageReceive: AnyPublisher<MessageReceiveType, Never> {
        return messageReceiveSubject.eraseToAnyPublisher()
    }
    
    private var thisConversation: (any Conversation)?
    private var isFetchEnabled: Bool = true
    private var allMessages: [Message.ID: Message] = [:]
    private var messageIdentifiers: [UUID] = []
    private var cancelBag: Set<AnyCancellable> = []
    
    private let messageReceiveSubject = PassthroughSubject<MessageReceiveType, Never>()

    private let conversationID: UUID
    private let historyBatchSize: Int
    private let conversationUseCase: ConversationUseCase
    private let sendMessageUseCase: SendMessageUseCase
    private let fetchConversationHistoryUseCase: FetchConversationHistoryUseCase
    private let streamMessageUpdatesUseCase: StreamMessageUpdatesUseCase
    
    init(
        channelID: UUID,
        historyBatchSize: Int = 50,
        conversationUseCase: ConversationUseCase,
        sendMessageUseCase: SendMessageUseCase,
        fetchConversationHistoryUseCase: FetchConversationHistoryUseCase,
        streamMessageUpdatesUseCase: StreamMessageUpdatesUseCase
    ) {
        self.conversationID = channelID
        self.historyBatchSize = historyBatchSize
        self.conversationUseCase = conversationUseCase
        self.sendMessageUseCase = sendMessageUseCase
        self.fetchConversationHistoryUseCase = fetchConversationHistoryUseCase
        self.streamMessageUpdatesUseCase = streamMessageUpdatesUseCase
        prepareConversation()
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
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
        let sendMessageCommand = SendMessageCommand(
            message: userMessageText,
            conversationIdentifier: conversationID
        )
        Task {
            await self.sendMessageUseCase.execute(sendMessageCommand)
            self.userMessageText.removeAll()
        }
    }
    
    func message(for identifier: UUID) -> ConversationMessageViewModel? {
        guard let message = allMessages[identifier] else {
            return nil
        }
        return ConversationMessageViewModel(message: message)
    }
    
    // MARK: Private Function(s)
    
    private func prepareConversation() {
        Task {
            let result = await conversationUseCase.fetchConversation(conversationID)
            switch result {
            case .success(let conversationType):
                switch conversationType {
                case .group(let conversation):
                    self.thisConversation = conversation
                case .private(let conversation):
                    self.thisConversation = conversation
                }
                startListening()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func startListening() {
        guard let thisConversation else {return}
        let streamTask = Task {
            let result = try await streamMessageUpdatesUseCase.execute(thisConversation)
            for await message in result {
                allMessages[message.id] = message
                messageIdentifiers.append(message.id)
                messageReceiveSubject.send(.new(message.id))
            }
        }
        cancelBag.insert(AnyCancellable(streamTask.cancel))
    }
    
    private func fetchChatHistories() async -> Bool {
        
        var messageQuery: MessageQuery = .mostRecent
        
        if let lastIdentifier = self.messageIdentifiers.first,
           let lastMessage = allMessages[lastIdentifier] {
            messageQuery = .before(lastMessage)
        }
        
        let result = await fetchConversationHistoryUseCase
            .execute(FetchConversationHistoryCommand(
                conversationIdentifier: conversationID,
                query: messageQuery,
                limit: 40
            ))
        
        guard case .success(let historyItems) = result else {
            return false
        }
        
        var historyIdentifiers = [UUID]()
        for historyItem in historyItems.reversed() {
            if case .message(let message) = historyItem {
                allMessages[message.id] = message
                historyIdentifiers.append(message.id)
            }
        }
        messageIdentifiers.insert(contentsOf: historyIdentifiers, at: .zero)
        messageReceiveSubject.send(.history(historyIdentifiers))
        return true
    }
}
