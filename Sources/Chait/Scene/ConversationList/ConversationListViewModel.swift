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
    
    private typealias Section<Item: Identifiable> = ListSection<SectionType, Item>
    
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
    private let fetchConversationSummaries: FetchConversationSummariesUseCase
    
    init(fetchConversationSummaries: FetchConversationSummariesUseCase) {
        self.fetchConversationSummaries = fetchConversationSummaries
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        viewActionSubject.send(.createSections(identifiers: [conversationListSection.id]))
        fetchConversationList()
    }
    
    func item(for identifier: UUID) -> ConversationSummaryViewModel? {
        return conversationListSection.item(for: identifier)
    }
    
    //MARK: Private Function(s)
    
    private func fetchConversationList() {
        Task.detached(priority: .background) {
            let conversationSummaries = try await self.fetchConversationSummaries.execute()
            let conversationViewModels = conversationSummaries.map { ConversationSummaryViewModel($0) }
            self.conversationListSection.insertItems(conversationViewModels)
            self.viewActionSubject.send(.insertItems(identifiers: conversationViewModels.map(\.id)))
        }
    }
}
