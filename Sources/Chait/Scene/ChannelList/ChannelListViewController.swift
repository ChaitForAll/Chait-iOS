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
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        viewModel?.fetchedChannels
            .sink {
                var snapShot = NSDiffableDataSourceSnapshot<Section, ChannelPresentationModel.ID>()
                snapShot.appendSections([.channelList])
                snapShot.appendItems($0)
                self.diffableDataSource?.apply(snapShot)
            }
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

