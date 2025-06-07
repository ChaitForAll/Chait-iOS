//
//  ConversationListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class ConversationListViewModel {
    
    // MARK: Property(s)
    
    @Published var summaryIdentifiers: [ConversationSummaryViewModel.ID] = []
    private var summaries: [ConversationSummaryViewModel.ID: ConversationSummaryViewModel] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    
    // MARK: Dependency(s)
    
    private let fetchConversationSummaries: FetchConversationSummariesUseCase

    init(fetchConversationSummaries: FetchConversationSummariesUseCase) {
        self.fetchConversationSummaries = fetchConversationSummaries
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        fetchConversationList()
    }
    
    func item(for identifier: UUID) -> ConversationSummaryViewModel? {
        return summaries[identifier]
    }
    
    //MARK: Private Function(s)
    
    private func fetchConversationList() {
        Task { [weak self] in
            guard let self else { return }
            let summaries = try await fetchConversationSummaries.execute()
            let summaryViewModels = summaries.map(ConversationSummaryViewModel.init)
            let newSummaryIdentifiers = summaryViewModels.map(\.id)
            for summary in summaryViewModels {
                self.summaries[summary.id] = summary
            }
            summaryIdentifiers.append(contentsOf: newSummaryIdentifiers)
        }
    }
}
