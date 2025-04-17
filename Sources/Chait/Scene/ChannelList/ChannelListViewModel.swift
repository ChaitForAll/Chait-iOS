//
//  ChannelListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class ChannelListViewModel {
    
    struct Output {
        let fetchedChannelListItems: AnyPublisher<[UUID], Never>
    }
    
    // MARK: Property(s)
    
    private var conversationSummaries: [UUID: ConversationSummaryViewModel] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let conversationSummariesSubject: PassthroughSubject<[UUID], Never> = .init()
    private let conversationUseCase: ConversationUseCase
    
    init(conversationUseCase: ConversationUseCase) {
        self.conversationUseCase = conversationUseCase
    }
    
    // MARK: Function(s)
    
    func bindOutput() -> Output {
        return Output(fetchedChannelListItems: conversationSummariesSubject.eraseToAnyPublisher())
    }
    
    func onNeedItems() {
        conversationUseCase
            .fetchConversationSummaryList()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] conversationSummaries in
                    conversationSummaries
                        .map { ConversationSummaryViewModel($0) }
                        .forEach { summaryViewModel in
                            self?.conversationSummaries[summaryViewModel.id] = summaryViewModel
                            self?.conversationSummariesSubject.send([summaryViewModel.id])
                        }
                }
            )
            .store(in: &cancelBag)
    }
    
    func item(for identifier: UUID) -> ConversationSummaryViewModel? {
        return conversationSummaries[identifier]
    }
}

