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
    private var lastOffset: CGFloat = .zero
    
    private var minCurrentBatchHeight: CGFloat = .zero
    private var maxCurrentBatchHeight: CGFloat = .zero
    
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
        configurePullToFetchHistory()
        configureNavigationItem()
        bindViewModel()
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
    
    private func createMessageCellRegisration(
    ) -> UICollectionView.CellRegistration<UICollectionViewListCell, UUID> {
        return .init { [weak self] cell, indexPath, messageID in

            var content = cell.defaultContentConfiguration()
            if let message = self?.viewModel?.message(for: messageID) {
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
        let output = viewModel?.bindOutput()
        output?
            .onReceiveNewMessages
            .sink { [weak self] newMessageIdentifiers in
                self?.addNewMessages(newMessageIdentifiers)
            }
            .store(in: &cancelBag)
        
        output?
            .onReceiveChatHistories
            .sink { [weak self] chatHistoryIdentifiers in
                self?.insertChatHistories(chatHistoryIdentifiers)
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
    
    private func addNewMessages(_ newMessages: [UUID]) {
        guard var snapShot = diffableDataSource?.snapshot() else {
            return
        }
        
        if snapShot.sectionIdentifiers.isEmpty {
            snapShot.appendSections([.messages])
        }
        
        snapShot.appendItems(newMessages)
        diffableDataSource?.apply(snapShot)
    }
    
    private func insertChatHistories(_ chatHistories: [UUID]) {
        guard var snapShot = diffableDataSource?.snapshot() else {
            return
        }
        
        let isSnapshotEmptyBeforeAddingItems = snapShot.itemIdentifiers.isEmpty
        
        if snapShot.sectionIdentifiers.isEmpty {
            snapShot.appendSections([.messages])
        }
        
        if let lastMessage = snapShot.itemIdentifiers.first {
            snapShot.insertItems(chatHistories, beforeItem: lastMessage)
        } else {
            snapShot.appendItems(chatHistories)
        }
        
        diffableDataSource?.apply(snapShot, animatingDifferences: true) { [weak self] in
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

extension PersonalChatViewController {
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
