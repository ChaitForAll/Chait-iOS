//
//  FetchImageUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine
import UIKit

enum ImageError: Error {
    case unknown
}

protocol FetchImageUseCase {
    func fetchImage(url: URL) -> AnyPublisher<UIImage, ImageError>
}

final class DefaultFetchImageUseCase: FetchImageUseCase {
    
    // MARK: Property(s)
    
    private let imageRepository: ImageRepository
    
    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }
    
    // MARK: Function(s)
    
    func fetchImage(url: URL) -> AnyPublisher<UIImage, ImageError> {
        return imageRepository.fetchImage(url: url)
    }
}
