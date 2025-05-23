//
//  FriendListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

final class FriendListViewController: UIViewController {
    
    // MARK: Type(s)
    
    enum Section {
        case friends
    }
    
    // MARK: Property(s)
    
    var viewModel: FriendListViewModel?
    private var cancelBag: Set<AnyCancellable> = .init()
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
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
        let output = viewModel?.bind()
        output?.fetchedFriendList
            .sink { friendIdentifiers in
                print(friendIdentifiers)
                guard var snapShot = self.diffableDataSource?.snapshot() else {
                    return
                }
                if snapShot.sectionIdentifiers.isEmpty {
                    snapShot.appendSections([.friends])
                }
                snapShot.appendItems(friendIdentifiers)
                self.diffableDataSource?.apply(snapShot)
            }
            .store(in: &cancelBag)
    }
    
    private func configureCollectionView() {
        self.diffableDataSource = createDiffableDataSource()
        collectionView.collectionViewLayout = createListLayout()
        collectionView.dataSource = diffableDataSource
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
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
        return UICollectionView.CellRegistration<UICollectionViewListCell, UUID> {
            cell, indexPath, itemIdentifier in
            
            var content = cell.defaultContentConfiguration()
            content.image = [
                UIImage(systemName: "square.fill"),
                UIImage(systemName: "circle.fill"),
                UIImage(systemName: "triangle.fill")
            ].randomElement() ?? .none
            content.text = "User \(indexPath.item)"
            content.secondaryText = itemIdentifier.uuidString
            cell.contentConfiguration = content
        }
    }
}
