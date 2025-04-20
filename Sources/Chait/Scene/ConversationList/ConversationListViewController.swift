//
//  ConversationListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

final class ConversationListViewController: UIViewController {
    
    enum Section {
        case channelList
    }
    
    // MARK: Property(s)
    
    var viewModel: ConversationListViewModel?
    var coordinator: AppCoordinator?
    
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
        self.collectionView.delegate = self
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
            content.image = [
                UIImage(systemName: "square.fill"),
                UIImage(systemName: "circle.fill"),
                UIImage(systemName: "triangle.fill")
            ].randomElement() ?? .none
            content.text = item?.title
            content.secondaryText = item?.id.uuidString
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

extension ConversationListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let id = diffableDataSource?.itemIdentifier(for: indexPath),
            let conversation = viewModel?.item(for: id) {
            coordinator?.enterChannel(conversation.conversationID)
        }
    }
}
