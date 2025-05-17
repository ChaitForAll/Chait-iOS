//
//  FriendListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import UIKit
import Combine

final class FriendListViewController: UIViewController {
    typealias SnapShot = NSDiffableDataSourceSnapshot<UUID, UUID>
    typealias DataSource = UICollectionViewDiffableDataSource<UUID, UUID>
    typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UUID>
    
    // MARK: Property(s)
    
    var viewModel: FriendListViewModel?
    
    private var cancelBag: Set<AnyCancellable> = .init()
    private var diffableDataSource: DataSource?
    private var currentSnapshot: SnapShot? {
        return diffableDataSource?.snapshot()
    }
    
    private let collectionView = UICollectionView.withEmptyLayout()
    
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
                    var snapShot = SnapShot()
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
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        var separator = listConfiguration.separatorConfiguration
        let separatorInset = NSDirectionalEdgeInsets(top: 0, leading: 77, bottom: 0, trailing: 0)
        separator.topSeparatorInsets = separatorInset
        separator.bottomSeparatorInsets = separatorInset
        listConfiguration.separatorConfiguration = separator
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    private func createDiffableDataSource() -> DataSource {
        let listCellRegistration = createListCellRegistration()
        return DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: listCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
    
    private func createListCellRegistration() -> ListCellRegistration {
        return ListCellRegistration { cell, indexPath, itemIdentifier in
            
            var content = cell.friedListContentConfiguration()
            
            if let friend = self.viewModel?.friendViewModel(for: itemIdentifier) {
                content.name = friend.displayName
                content.status = friend.createdAt.formatted()
                content.image = friend.image
            }
            cell.contentConfiguration = content
        }
    }
}

// MARK: UICollectionViewDelegate

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
