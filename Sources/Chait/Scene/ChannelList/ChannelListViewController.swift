//
//  ChannelListViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class ChannelListViewController: UIViewController {
    
    // MARK: Property(s)
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: Override(s)
    
    override func loadView() {
        self.view = collectionView
    }
    
    // MARK: Function(s)
    
    private func configureCollectionView() { }
}
