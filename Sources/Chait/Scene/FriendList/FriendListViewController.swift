//
//  FriendListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import UIKit
import Combine

final class FriendListViewController: UIViewController {
    
    // MARK: Type(s)
    
    private enum Section {
        case contacts
    }
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, UUID>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UUID>
    private typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UUID>
    
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
        viewModel?.$friendIdentifiers
            .sink { [weak self] friendIdentifiers in
                guard var currentSnapshot = self?.currentSnapshot else { return }
                if currentSnapshot.sectionIdentifiers.isEmpty {
                    currentSnapshot.appendSections([.contacts])
                }
                currentSnapshot.appendItems(friendIdentifiers)
                self?.diffableDataSource?.apply(currentSnapshot)
            }
            .store(in: &cancelBag)
    }
    
    private func configureCollectionView() {
        self.diffableDataSource = createDiffableDataSource()
        configureSupplementaryProvider()
        collectionView.collectionViewLayout = createListLayout()
        collectionView.dataSource = diffableDataSource
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        var separator = listConfiguration.separatorConfiguration
        let separatorInset = NSDirectionalEdgeInsets(top: 0, leading: 77, bottom: 0, trailing: 0)
        separator.topSeparatorInsets = separatorInset
        separator.bottomSeparatorInsets = separatorInset
        listConfiguration.separatorConfiguration = separator
        listConfiguration.headerMode = .supplementary
        listConfiguration.headerTopPadding = .zero
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
        return ListCellRegistration { [weak self] cell, indexPath, itemIdentifier in
            var content = cell.friedListContentConfiguration()
            content.viewModel = self?.viewModel?.friendViewModel(for: itemIdentifier)
            cell.contentConfiguration = content
        }
    }
    
    private func sectionHeaderRegistration(
    ) -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
        return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] supplementaryView, kind, indexPath in
            var content = supplementaryView.defaultContentConfiguration()
            if let currentSnapshot = self?.currentSnapshot {
                content.text = String("\(currentSnapshot.itemIdentifiers.count) friends")
            }
            supplementaryView.contentConfiguration = content
        }
    }
    
    private func configureSupplementaryProvider() {
        let sectionHeaderRegistration = sectionHeaderRegistration()
        diffableDataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: sectionHeaderRegistration,
                for: indexPath
            )
        }
    }
}
