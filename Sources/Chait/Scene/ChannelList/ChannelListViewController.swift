//
//  ChannelListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class ChannelListViewController: UIViewController {
    
    enum Section {
        case channelList
    }
    
    // MARK: Property(s)
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    private var viewModel: ChannelListViewModel?
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = collectionView
    }
    
    // MARK: Function(s)
    
    private func configureCollectionView() { 
        self.collectionView.collectionViewLayout = createCompositionalLayout()
        self.collectionView.dataSource = diffableDataSource
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    private func createDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, UUID> {
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
        return .init { cell, indexPath, itemIdentifier in
            
            let item = self.viewModel?.item(for: itemIdentifier)
            var content = cell.defaultContentConfiguration()
            content.text = item?.title
            cell.contentConfiguration = content
        }
    }
}
