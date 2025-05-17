
//
//  UICollectionView+EmptyLayout.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import UIKit

extension UICollectionView {
    static func withEmptyLayout() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: .init())
    }
}

