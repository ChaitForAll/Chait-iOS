//
//  ConversationListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class ConversationListViewModel {
    
    // MARK: Type(s)
    
    private enum SectionType: CaseIterable {
        case conversationList
    }
    
    private typealias Section<ItemIdentifier: Identifiable> = ListSection<SectionType, ItemIdentifier>
    
    enum ViewAction {
        case createSections(identifiers: [UUID])
        case insertItems(identifiers: [UUID])
    }
    
    // MARK: Property(s)
    
    var viewAction: AnyPublisher<ViewAction, Never> {
        return viewActionSubject.eraseToAnyPublisher()
    }
    
    private var conversationListSection = Section<ConversationSummaryViewModel>(sectionType: .conversationList)
    private var viewActionSubject = PassthroughSubject<ViewAction, Never>()
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
        return conversationListSection.item(for: identifier)
    }
    
    //MARK: Private Function(s)
    
    private func fetchConversationList() {
        conversationUseCase
            .fetchConversationSummaryList()
            .replaceError(with: [])
            .map { $0.map  { ConversationSummaryViewModel($0) }}
            .handleEvents(receiveOutput: { [weak self] output in
                self?.conversationListSection.insertItems(output)
            })
            .map { viewModels in
                ViewAction.insertItems(identifiers: viewModels.map(\.id))
            }
            .sink { [weak self] in
                self?.viewActionSubject.send($0)
            }
            .store(in: &cancelBag)
    }
}
