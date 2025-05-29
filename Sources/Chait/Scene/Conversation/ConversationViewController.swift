//
//  ConversationViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

final class ConversationViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<UUID, UUID>
    typealias SnapShot = NSDiffableDataSourceSnapshot<UUID, UUID>
    typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, UUID>
    
    // MARK: Property(s)
    
    var viewModel: ConversationViewModel?
    
    private var lastOffset: CGFloat = .zero
    private var lastContentSize: CGSize = .zero
    private var minCurrentBatchHeight: CGFloat = .zero
    private var maxCurrentBatchHeight: CGFloat = .zero
    private var cancelBag: Set<AnyCancellable> = .init()
    private var diffableDataSource: DataSource?
    private var currentSnapshot: SnapShot? {
        return diffableDataSource?.snapshot()
    }
    
    private let collectionView = UICollectionView.withEmptyLayout()
    
    // MARK: Override(s)
    
//    override func loadView() {
////        self.view = collectionView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    private func createMessageCellRegistration() -> ListCellRegistration {
        return ListCellRegistration { [weak self] cell, indexPath, messageID in
            
            var content = cell.defaultContentConfiguration()
            
            if let message = self?.viewModel?.message(for: messageID) {
                content.text = message.text
                content.secondaryText = message.createdAt.description
            }
            
            cell.contentConfiguration = content
        }
    }
    
    private func createDiffableDataSource() -> DataSource {
        let messageCellRegistration = createMessageCellRegistration()
        return DataSource(collectionView: collectionView) {
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
                switch viewAction {
                case .createSections(identifiers: let sections):
                    var initialSnapshot = SnapShot()
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
            .filter { offset in
                let isScrollingUp = self.lastOffset > offset.y
                let currentPosition = self.maxCurrentBatchHeight - offset.y - topSafeInset
                let lastContentSize = self.maxCurrentBatchHeight - self.minCurrentBatchHeight
                let normalizedScrollValue =  (currentPosition - self.minCurrentBatchHeight) / lastContentSize
                self.lastOffset = offset.y
                return ((0.84...1.0) ~= normalizedScrollValue && isScrollingUp)
            }
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .sink { offset in
                self.viewModel?.onReachTop()
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
        lastContentSize = self.collectionView.contentSize
        diffableDataSource?.apply(currentSnapshot, animatingDifferences: true) { [weak self] in
            guard let self = self else { return }
            self.collectionView.layoutIfNeeded()

            let contentHeight = self.collectionView.contentSize.height
            let visibleHeight = self.collectionView.bounds.height - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom

            let targetOffsetY = max(contentHeight - visibleHeight, 0)
            self.collectionView.setContentOffset(CGPoint(x: 0, y: targetOffsetY), animated: false)
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
