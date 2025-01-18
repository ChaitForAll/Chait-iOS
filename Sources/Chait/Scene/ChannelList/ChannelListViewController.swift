//
//  ChannelListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import UIKit
import Combine

final class ChannelListViewController: UIViewController {
    
    // MARK: Type(s)
    
    enum Section {
        case channelList
    }
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, ChannelPresentationModel.ID>
    typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ChannelPresentationModel.ID>
    
    // MARK: Property(s)
    
    var viewModel: ChannelListViewModel?
    
    private var diffableDataSource: DiffableDataSource?
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let collectionView: UICollectionView = .init(
        frame: .zero, collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindViewModel()
        viewModel?.prepareChannels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationItems()
    }
    
    // MARK: Private Function(s)
    
    private func configureNavigationItems() {
        tabBarController?.navigationItem.title = "Channels"
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddChannelButton)
        )
    }
    
    @objc private func didTapAddChannelButton() {
        let alertController = UIAlertController(
            title: "Creating Channel",
            message: "Please enter channel title.",
            preferredStyle: .alert
        )
        alertController.addTextField()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] action in
            let channelTitle = alertController.textFields?.first?.text ?? ""
            self?.viewModel?.createNewChannel(channelTitle) { failureMessage in
                self?.presetCreateChannelFailed(with: failureMessage)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
    
    private func presetCreateChannelFailed(with message: String) {
        let failedAlertController = UIAlertController(
            title: "Failed to create",
            message: message,
            preferredStyle: .alert
        )
        failedAlertController.addAction(.init(title: "ok", style: .cancel))
        self.present(failedAlertController, animated: true)
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }
        viewModel.startListeningChannelUpdates()
        viewModel.fetchedChannels
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { newChannels in
                
                guard var snapshot = self.diffableDataSource?.snapshot() else {
                    return
                }
                
                if !snapshot.sectionIdentifiers.contains(where: { $0 == .channelList }) {
                    snapshot.appendSections([.channelList])
                }

                snapshot.appendItems(newChannels, toSection: .channelList)
                self.diffableDataSource?.apply(snapshot)
            })
            .store(in: &cancelBag)
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(createListLayout(), animated: false)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        self.diffableDataSource = createDataSource()
    }
    
    private func createListCellRegistration() -> ListCellRegistration {
        return ListCellRegistration { [weak self] cell, indexPath, itemIdentifier in
            
            var cellContent = cell.defaultContentConfiguration()
            if let channelModel = self?.viewModel?.channel(for: itemIdentifier) {
                cellContent.text = channelModel.title
                cellContent.image = UIImage(systemName: "rectangle.fill")
            }
            cell.contentConfiguration = cellContent
        }
    }
    
    private func createDataSource() -> DiffableDataSource {
        let cellRegistration = createListCellRegistration()
        let dataSource = DiffableDataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        return dataSource
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}
