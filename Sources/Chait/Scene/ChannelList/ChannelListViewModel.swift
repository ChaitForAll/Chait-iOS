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
    
    private var itemsInOrder: [ChannelListItem] = []
    private var itemsMap: [ChannelListItem.ID: ChannelListItem] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let fetchedChannelListItems: PassthroughSubject<[UUID], Never> = .init()
    
    private let fetchChannelListUseCase: FetchChannelListUseCase
    private let userID: UUID
    
    init(fetchChannelListUseCase: FetchChannelListUseCase, userID: UUID) {
        self.fetchChannelListUseCase = fetchChannelListUseCase
        self.userID = userID
    }
    
    // MARK: Function(s)
    
    func bindOutput() -> Output {
        return Output(fetchedChannelListItems: fetchedChannelListItems.eraseToAnyPublisher())
    }
    
    func onNeedItems() {
        fetchChannelListUseCase.fetchChannels(userID)
            .map { channels in
                channels.map {
                    ChannelListItem(id: $0.channelID, title: $0.title)
                }
            }
            .sink { _ in
                // TODO: Add Error handling flow
            } receiveValue: { [weak self] items in
                items.forEach { self?.itemsMap[$0.id] = $0 }
                self?.itemsInOrder.append(contentsOf: items)
                self?.fetchedChannelListItems.send(items.map { $0.id })
            }
            .store(in: &cancelBag)
    }
    
    func item(for identifier: UUID) -> ChannelListItem? {
        return itemsMap[identifier]
    }
}

