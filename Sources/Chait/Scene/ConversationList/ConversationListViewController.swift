//
//  ConversationListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

final class ConversationListViewController: UIViewController {
    typealias SnapShot = NSDiffableDataSourceSnapshot<UUID, UUID>
    typealias DataSource = UICollectionViewDiffableDataSource<UUID, UUID>
    typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UUID>
    
    // MARK: Property(s)
    
    var viewModel: ConversationListViewModel?
    var coordinator: AppCoordinator?
    
    private var cancelBag: Set<AnyCancellable> = .init()
    private var diffableDataSource: DataSource?
    private var currentSnapshot: SnapShot? {
        diffableDataSource?.snapshot()
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
    
    // MARK: Function(s)
    
    private func configureCollectionView() { 
        self.diffableDataSource = createDiffableDataSource()
        self.collectionView.collectionViewLayout = createCompositionalLayout()
        self.collectionView.dataSource = diffableDataSource
        self.collectionView.delegate = self
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
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
            
            let item = self.viewModel?.item(for: itemIdentifier)
            var content = cell.defaultContentConfiguration()
            content.image = [
                UIImage(systemName: "square.fill"),
                UIImage(systemName: "circle.fill"),
                UIImage(systemName: "triangle.fill")
            ].randomElement() ?? .none
            content.text = item?.title
//            content.secondaryText = item?.id.uuidString
            content.secondaryText = "me: What the fuck?"
            cell.accessories = [.disclosureIndicator()]
            cell.contentConfiguration = content
        }
    }
    
    private func bindViewModel() {
        viewModel?.viewAction
            .sink { [weak self] viewAction in
                switch viewAction {
                    
                case.createSections(identifiers: let sectionIdentifiers):
                    var initialSnapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
                    initialSnapshot.appendSections(sectionIdentifiers)
                    self?.diffableDataSource?.apply(initialSnapshot)
                    
                case .insertItems(identifiers: let items):
                    guard var currentSnapshot = self?.currentSnapshot,
                            !currentSnapshot.sectionIdentifiers.isEmpty
                    else {
                        return
                    }
                    currentSnapshot.appendItems(items)
                    self?.diffableDataSource?.apply(currentSnapshot)
                }
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
