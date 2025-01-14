//
//  ChannelListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class ChannelListViewController: UIViewController {
    
    // MARK: Type(s)
    
    enum Section {
        case channelList
    }
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, ChannelPresentationModel.ID>
    
    // MARK: Property(s)
    
    private var diffableDataSource: DiffableDataSource?
    
    private let collectionView: UICollectionView = .init(
        frame: .zero, collectionViewLayout: .init()
    )
    
    // MARK: Override(s)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(createListLayout(), animated: false)
        collectionView.backgroundColor = .systemGreen
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        self.diffableDataSource = createDataSource()
    }
    
    // MARK: Private Function(s)
    
    private func createDataSource() -> DiffableDataSource {
        let dataSource = DiffableDataSource(collectionView: collectionView) { 
            collectionView, indexPath, itemIdentifier in
            
            return UICollectionViewCell()
        }
        return dataSource
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

