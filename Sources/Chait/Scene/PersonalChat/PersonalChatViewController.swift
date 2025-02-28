//
//  PersonalChatViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

final class PersonalChatViewController: UIViewController {
    
    // MARK: Type(s)
    
    private enum Section {
        case messages
    }
    
    // MARK: Property(s)
    
    var viewModel: PersonalChatViewModel?
    
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
        configureNavigationItem()
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
    ) -> UICollectionView.CellRegistration<UICollectionViewListCell, UUID> {
        return .init { cell, indexPath, messageID in

            var content = cell.defaultContentConfiguration()
            if let message = self.viewModel?.message(for: messageID) {
                content.text = message.text
                content.secondaryText = message.createdAt.description
            }
            cell.contentConfiguration = content
        }
    }
    
    private func createDiffableDataSource(
    ) -> UICollectionViewDiffableDataSource<Section, UUID> {
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
            .sink { identifier in
                
                guard var snapShot = self.diffableDataSource?.snapshot() else {
                    return
                }
                
                if snapShot.sectionIdentifiers.isEmpty {
                    snapShot.appendSections([.messages])
                }
                
                snapShot.appendItems([identifier])
                self.diffableDataSource?.apply(snapShot)
            }
            .store(in: &cancelBag)
    }
    
    private func configureNavigationItem() {
        let rightBarButton = UIBarButtonItem(systemItem: .add)
        rightBarButton.primaryAction = UIAction(title: "Add Message") { [weak self] action in
            self?.presentAddMessage()
        }
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func presentAddMessage() {
        let writeMessageAlert = UIAlertController(
            title: "Send message",
            message: "Type message to send",
            preferredStyle: .alert
        )
        writeMessageAlert.addTextField { textField in
            textField.placeholder = "message"
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        let sendAction = UIAlertAction(title: "send", style: .default) { [weak self] _ in
            if let userInput = writeMessageAlert.textFields?.first?.text {
                self?.viewModel?.userMessageText = userInput
            }
        }
        writeMessageAlert.addAction(cancelAction)
        writeMessageAlert.addAction(sendAction)
        present(writeMessageAlert, animated: true)
    }
}
