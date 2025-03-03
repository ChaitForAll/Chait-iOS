//
//  ChannelListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

final class ChannelListViewController: UIViewController {
    
    enum Section {
        case channelList
    }
    
    // MARK: Property(s)
    
    var viewModel: ChannelListViewModel?
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    private var cancelBag: Set<AnyCancellable> = .init()
    
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
        viewModel?.onNeedItems()
    }
    
    // MARK: Function(s)
    
    private func configureCollectionView() { 
        self.diffableDataSource = createDiffableDataSource()
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
    
    private func bindViewModel() {
        let output = viewModel?.bindOutput()
        
        output?
            .fetchedChannelListItems
            .sink { [weak self] itemIdentifiers in
                
                guard var snapShot = self?.diffableDataSource?.snapshot() else {
                    return
                }
                
                if snapShot.sectionIdentifiers.isEmpty {
                    snapShot.appendSections([.channelList])
                }
                
                snapShot.appendItems(itemIdentifiers)
                
                self?.diffableDataSource?.apply(snapShot)
            }
            .store(in: &cancelBag)
    }
}
