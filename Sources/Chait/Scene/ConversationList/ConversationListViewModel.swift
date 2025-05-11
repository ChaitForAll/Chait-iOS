//
//  ConversationListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class ConversationListViewModel {
    
    // MARK: Type(s)
    
    enum ViewAction {
        case insertItems(identifiers: [UUID])
    }
    
    // MARK: Property(s)
    
    var viewAction: AnyPublisher<ViewAction, Never> {
        return viewActionSubject.eraseToAnyPublisher()
    }
    
    private var viewActionSubject = PassthroughSubject<ViewAction, Never>()
    private var conversationSummaries: [UUID: ConversationSummaryViewModel] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let conversationSummariesSubject: PassthroughSubject<[UUID], Never> = .init()
    private let conversationUseCase: ConversationUseCase
    
    init(conversationUseCase: ConversationUseCase) {
        self.conversationUseCase = conversationUseCase
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        fetchConversationList()
    }
    
    func item(for identifier: UUID) -> ConversationSummaryViewModel? {
        return conversationSummaries[identifier]
    }
    
    //MARK: Private Function(s)
    
    private func fetchConversationList() {
        conversationUseCase
            .fetchConversationSummaryList()
            .replaceError(with: [])
            .map { $0.map  { ConversationSummaryViewModel($0) }}
            .handleEvents(
                receiveOutput: { [weak self] output in
                    output.forEach { viewModel in
                        self?.conversationSummaries[viewModel.id] = viewModel
                    }
                }
            )
            .map { viewModels in
                ViewAction.insertItems(identifiers: viewModels.map(\.id))
            }
            .sink(receiveValue: viewActionSubject.send)
            .store(in: &cancelBag)
    }
}
