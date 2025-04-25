//
//  ImageRepositoryImplementation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine
import UIKit

final class ImageRepositoryImplementation: ImageRepository {
    
    // MARK: Property(s)
    
    private let imageManager: ImageManager
    
    init(imageManager: ImageManager = ImageManager()) {
        self.imageManager = imageManager
    }
    
    // MARK: Function(s)
    
    func fetchImage(url: URL) -> AnyPublisher<UIImage, ImageError> {
        return imageManager.downloadBackground(url: url)
            .mapError { error in
                switch error {
                case .unknown:
                    return ImageError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
