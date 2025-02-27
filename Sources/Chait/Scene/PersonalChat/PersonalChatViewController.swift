//
//  PersonalChatViewController.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class PersonalChatViewController: UIViewController {
    
    // MARK: Property(s)
    
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
    }
    
    // MARK: Private Function(s)
    
    private func configureCollectionView() { }
}
