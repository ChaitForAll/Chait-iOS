//
//  PersonalChatViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class PersonalChatViewController: UIViewController {
    
    // MARK: Type(s)
    
    enum Section {
        case messages
    }
    
    // MARK: Property(s)
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, String>?
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = collectionView
        collectionView.backgroundColor = .systemGreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: Private Function(s)
    
    private func configureCollectionView() {
        self.diffableDataSource = createDiffableDataSource()
        collectionView.dataSource = diffableDataSource
        collectionView.collectionViewLayout = createListCollectionViewLayout()
    }
    
    private func createListCollectionViewLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func createMessageCellRegisration(
    ) -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return .init { cell, indexPath, messageText in

            var content = cell.defaultContentConfiguration()
            content.text = messageText
            cell.contentConfiguration = content
        }
    }
    
    private func createDiffableDataSource(
    ) -> UICollectionViewDiffableDataSource<Section, String> {
        let messageCellRegistration = createMessageCellRegisration()
        return .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(
                using: messageCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
}
