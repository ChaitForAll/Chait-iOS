//
//  ImageRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Combine
import UIKit

protocol ImageRepository {
    func fetchImage(url: URL) -> AnyPublisher<UIImage, ImageError>
}
