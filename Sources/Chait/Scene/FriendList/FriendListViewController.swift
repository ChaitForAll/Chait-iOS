//
//  FriendListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

final class FriendListViewController: UIViewController {
    
    // MARK: Property(s)
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = collectionView
    }
    
    // MARK: Private Function(s)
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = createListLayout()
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
}
