//
//  ImageManager.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Combine

enum NetworkError: Error {
    case unknown
}

final class ImageManager {
    
    // MARK: Property(s)
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: Function(s)
    
    func downloadBackground(url: URL) -> AnyPublisher<UIImage, NetworkError>  {
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let image = UIImage(data: data) else {
                    throw NetworkError.unknown
                }
                return image
            }
            .mapError { _ in return NetworkError.unknown }
            .eraseToAnyPublisher()
            
    }
}
