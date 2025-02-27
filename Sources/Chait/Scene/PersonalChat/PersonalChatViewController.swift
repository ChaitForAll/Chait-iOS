//
//  PersonalChatViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

final class PersonalChatViewController: UIViewController {
    
    // MARK: Type(s)
    
    enum Section {
        case messages
    }
    
    // MARK: Property(s)
    
    var viewModel: PersonalChatViewModel?
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, String>?
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = collectionView
        collectionView.backgroundColor = .systemGreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindViewModel()
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
    
    private func bindViewModel() {
        viewModel?.startListening()
        viewModel?.messages
            .publisher
            .sink { [weak self] message in
                guard var snapshot = self?.diffableDataSource?.snapshot() else {
                    return
                }
                
                if snapshot.sectionIdentifiers.isEmpty {
                    snapshot.appendSections([.messages])
                }
                
                snapshot.appendItems([message])
                self?.diffableDataSource?.apply(snapshot)
            }
            .store(in: &cancelBag)
    }
}
