//
//  ConversationViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

final class ConversationViewController: UIViewController {
    
    // MARK: Property(s)
    
    var viewModel: ConversationViewModel?
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<UUID, UUID>?
    private var cancelBag: Set<AnyCancellable> = .init()
    private var lastOffset: CGFloat = .zero
    private var minCurrentBatchHeight: CGFloat = .zero
    private var maxCurrentBatchHeight: CGFloat = .zero
    
    private var currentSnapshot: NSDiffableDataSourceSnapshot<UUID, UUID>? {
        return diffableDataSource?.snapshot()
    }
    
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
        configurePullToFetchHistory()
        viewModel?.onViewDidLoad()
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
    
    private func createMessageCellRegistration(
    ) -> UICollectionView.CellRegistration<UICollectionViewListCell, UUID> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, UUID> {
            [weak self] cell, indexPath, messageID in

            var content = cell.defaultContentConfiguration()
            if let message = self?.viewModel?.message(for: messageID) {
                content.text = message.text
                content.secondaryText = message.createdAt.description
            }
            cell.contentConfiguration = content
        }
    }
    
    private func createDiffableDataSource() -> UICollectionViewDiffableDataSource<UUID, UUID> {
        let messageCellRegistration = createMessageCellRegistration()
        return UICollectionViewDiffableDataSource<UUID, UUID>(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: messageCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
    
    private func bindViewModel() {
        viewModel?.viewAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewAction in
                print(viewAction)
                switch viewAction {
                case .createSections(identifiers: let sections):
                    var initialSnapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
                    initialSnapshot.appendSections(sections)
                    self?.diffableDataSource?.apply(initialSnapshot)
                case .appendItems(identifiers: let identifiers):
                    self?.appendItems(identifiers)
                case .insertItemsAtTop(identifiers: let identifiers):
                    self?.insertItemsAtTop(identifiers)
                }
            }
            .store(in: &cancelBag)
    }
    
    private func configurePullToFetchHistory() {
        let topSafeInset = collectionView.safeAreaInsets.top
        
        collectionView
            .publisher(for: \.contentOffset)
            .sink { [weak self] offset in
                guard let self, let viewModel else { return }
                
                let isScrollingUp = lastOffset > offset.y
                let currentPosition = maxCurrentBatchHeight - offset.y - topSafeInset
                let lastContentSize = maxCurrentBatchHeight - minCurrentBatchHeight
                let normalizedScrollValue =  (currentPosition - minCurrentBatchHeight) / lastContentSize
                
                if (0.84...1.0) ~= normalizedScrollValue, isScrollingUp {
                    viewModel.onReachTop()
                }
                lastOffset = offset.y
            }
            .store(in: &cancelBag)
    }
    
    private func appendItems(_ newMessages: [UUID]) {
        guard var currentSnapshot else { return }
        currentSnapshot.appendItems(newMessages)
        diffableDataSource?.apply(currentSnapshot)
    }
    
    private func insertItemsAtTop(_ chatHistories: [UUID]) {
        guard var currentSnapshot else { return }
        
        let isSnapshotEmptyBeforeAddingItems = currentSnapshot.itemIdentifiers.isEmpty
        
        if let lastMessage = currentSnapshot.itemIdentifiers.first {
            currentSnapshot.insertItems(chatHistories, beforeItem: lastMessage)
        } else {
            currentSnapshot.appendItems(chatHistories)
        }
        
        diffableDataSource?.apply(currentSnapshot, animatingDifferences: true) { [weak self] in
            guard let self else { return }
            
            minCurrentBatchHeight = maxCurrentBatchHeight
            maxCurrentBatchHeight = collectionView.contentSize.height
            
            guard !(collectionView.contentSize.height < collectionView.bounds.height) else {
                return
            }
            
            guard !isSnapshotEmptyBeforeAddingItems else {
                let actualOffset = collectionView.contentOffset.y + collectionView.safeAreaInsets.top
                let diff = collectionView.contentSize.height - collectionView.bounds.height - actualOffset
                collectionView.contentOffset.y = diff
                return
            }
        }
    }
    
    private func configureNavigationItem() {
        let rightBarButton = UIBarButtonItem(systemItem: .add)
        rightBarButton.primaryAction = UIAction { [weak self] action in
            self?.presentAddMessage()
        }
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // TODO: Replace with actual message input bar
    
    private func presentAddMessage() {
        let writeMessageAlert = UIAlertController(
            title: PersonalChatStrings.sendAlertTitle.string,
            message: PersonalChatStrings.sendAlertMessage.string,
            preferredStyle: .alert
        )
        writeMessageAlert.addTextField { textField in
            textField.placeholder = PersonalChatStrings.sendAlertTextFieldPlaceHolder.string
        }
        let cancelAction = UIAlertAction(title: PersonalChatStrings.cancel.string, style: .cancel)
        let sendAction = UIAlertAction(
            title: PersonalChatStrings.send.string,
            style: .default
        ) { [weak self] _ in
            if let userInput = writeMessageAlert.textFields?.first?.text {
                self?.viewModel?.userMessageText = userInput
                self?.viewModel?.onSendMessage()
            }
        }
        writeMessageAlert.addAction(cancelAction)
        writeMessageAlert.addAction(sendAction)
        present(writeMessageAlert, animated: true)
    }
}

extension ConversationViewController {
    private enum PersonalChatStrings {
        case sendAlertTitle
        case sendAlertMessage
        case sendAlertTextFieldPlaceHolder
        case cancel
        case send
        
        var string: String {
            switch self {
            case .sendAlertTitle: String(localized: "Send Message")
            case .sendAlertMessage: String(localized: "Type Message")
            case .sendAlertTextFieldPlaceHolder: String(localized: "Message")
            case .cancel: String(localized: "Cancel")
            case .send: String(localized: "Send")
            }
        }
    }
}
