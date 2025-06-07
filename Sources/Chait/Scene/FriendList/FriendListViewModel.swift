//
//  FriendListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine
import UIKit

final class FriendListViewModel {
    
    // MARK: Property(s)
    
    @Published var friendIdentifiers: [UUID] = []
    
    private var allFriends: [FriendViewModel.ID: FriendViewModel] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    private let fetchFriendsListUseCase: FetchFriendsListUseCase
    private let fetchImageUseCase: FetchImageUseCase
    
    init(
        fetchFriendsListUseCase: FetchFriendsListUseCase,
        fetchImageUseCase: FetchImageUseCase
    ) {
        self.fetchFriendsListUseCase = fetchFriendsListUseCase
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    // MARK: Function(s)
    
    func onViewDidLoad() {
        fetchFriendsList()
    }
    
    func friendViewModel(for id: UUID) -> FriendViewModel? {
        return allFriends[id]
    }
    
    // MARK: Private Function(s)
    
    private func fetchFriendsList() {
        fetchFriendsListUseCase.fetchFriendList()
            .map { $0.map { FriendViewModel(friend: $0) }}
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] viewModels in
                    for viewModel in viewModels {
                        self?.allFriends[viewModel.id] = viewModel
                    }
                    self?.friendIdentifiers.append(contentsOf: viewModels.map(\.id))
                }
            )
            .store(in: &cancelBag)
    }
}
