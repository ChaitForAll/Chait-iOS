//
//  FriendListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine
import UIKit

fileprivate enum SectionType: CaseIterable {
    case friendsList
}

final class FriendListViewModel {
    
    // MARK: Type(s)
    
    private typealias Section<Item: Identifiable> = ListSection<SectionType, Item>
    
    enum ViewAction {
        case createSections([UUID])
        case insert(items: [UUID], section: UUID)
        case update(items: [UUID])
    }
    
    // MARK: Property(s)
    
    var viewAction: AnyPublisher<ViewAction, Never> {
        return viewActionSubject.eraseToAnyPublisher()
    }
    
    private var cancelBag: Set<AnyCancellable> = .init()
    private var sections: [SectionType: Section<FriendViewModel>] = [:]
    
    private let viewActionSubject = PassthroughSubject<ViewAction, Never>()
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
        sections = [.friendsList: Section<FriendViewModel>(sectionType: .friendsList)]
        viewActionSubject.send(.createSections(sections.values.map { $0.id }))
        fetchFriendsList()
    }
    
    func onWillDisplayFriend(_ friendIdentifier: UUID) {
        if let friendViewModel = friendViewModel(for: friendIdentifier) {
            prepareImage(friendViewModel)
                .map { ViewAction.update(items: [$0]) }
                .sink { self.viewActionSubject.send($0) }
                .store(in: &cancelBag)
        }
    }
    
    func friendViewModel(for id: UUID) -> FriendViewModel? {
        return sections[.friendsList]?.item(for: id)
    }
    
    // MARK: Private Function(s)
    
    private func fetchFriendsList() {
        fetchFriendsListUseCase.fetchFriendList()
            .map { $0.map { FriendViewModel(friend: $0) }}
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] viewModels in
                    let section = self?.sections[.friendsList]
                    guard let sectionID = section?.id else { return }
                    section?.insertItems(viewModels)
                    let viewAction = ViewAction.insert(
                        items: viewModels.map { $0.id },
                        section: sectionID
                    )
                    self?.viewActionSubject.send(viewAction)
                }
            )
            .store(in: &cancelBag)
    }
    
    private func prepareImage(_ friendViewModel: FriendViewModel) -> AnyPublisher<UUID, Never> {
        fetchImageUseCase
            .fetchImage(url: friendViewModel.imageURL)
            .receive(on: DispatchQueue.main)
            .replaceError(with: UIImage.add) // TODO: Replace with default empty image
            .flatMap { image in
                friendViewModel.image = image
                return Just(friendViewModel.id)
            }
            .eraseToAnyPublisher()
    }
}
