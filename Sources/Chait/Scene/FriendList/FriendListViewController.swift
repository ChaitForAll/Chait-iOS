//
//  FriendListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import UIKit
import Combine

final class FriendListViewController: UIViewController {
    
    // MARK: Property(s)
    
    var viewModel: FriendListViewModel?
    
    private var cancelBag: Set<AnyCancellable> = .init()
    private var diffableDataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var currentSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>? {
        return diffableDataSource?.snapshot()
    }
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindViewModel()
        viewModel?.onViewDidLoad()
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.viewAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewAction in
                guard let self else { return }
                switch viewAction {
                    
                case .createSections(let sections):
                    var snapShot = NSDiffableDataSourceSnapshot<UUID, UUID>()
                    snapShot.appendSections(sections)
                    diffableDataSource?.apply(snapShot)
                    
                case .insert(items: let insertingItems, section: let section):
                    guard var currentSnapshot else { return }
                    currentSnapshot.appendItems(insertingItems, toSection: section)
                    diffableDataSource?.apply(currentSnapshot)
                    
                case .update(items: let updatingItems):
                    guard var currentSnapshot else { return }
                    currentSnapshot.reconfigureItems(updatingItems)
                    diffableDataSource?.apply(currentSnapshot)
                }
            }
            .store(in: &cancelBag)
    }
    
    private func configureCollectionView() {
        self.diffableDataSource = createDiffableDataSource()
        collectionView.collectionViewLayout = createListLayout()
        collectionView.dataSource = diffableDataSource
        collectionView.delegate = self
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    private func createDiffableDataSource() -> UICollectionViewDiffableDataSource<UUID, UUID> {
        let listCellRegistration = createListCellRegistration()
        return .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: listCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
    
    private func createListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, UUID> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, UUID> {
            cell, indexPath, itemIdentifier in
            
            var content = cell.friedListContentConfiguration()
            
            if let friend = self.viewModel?.friendViewModel(for: itemIdentifier) {
                content.name = friend.displayName
                content.status = friend.createdAt.formatted()
                content.image = friend.image
            }
            cell.directionalLayoutMargins.leading = content.separatorInset
            cell.contentConfiguration = content
        }
    }
}

extension FriendListViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let friendIdentifier = diffableDataSource?.itemIdentifier(for: indexPath) {
            viewModel?.onWillDisplayFriend(friendIdentifier)
        }
    }
}
