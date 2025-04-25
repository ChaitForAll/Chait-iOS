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
