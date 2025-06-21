//
//  ProfileImageDataService.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import Combine

enum UserImageServiceError: Error {
    case failed
    case unknown
}

final class UserImageService {
    
    // MARK: Property(s)
    
    private let fetchImageDataPort: FetchUserImageDataPort
    
    init(fetchImageDataPort: FetchUserImageDataPort) {
        self.fetchImageDataPort = fetchImageDataPort
    }
    
    // MARK: Function(s)
    
    func fetchImageData(
        _ command: FetchUserImageCommand
    ) -> AnyPublisher<UserImage, UserImageServiceError> {
        return fetchImageDataPort.fetchImageData(command)
            .mapError { fetchImageDataPortError in
                switch fetchImageDataPortError {
                case .unknown:
                    return .unknown
                case .failed:
                    return .failed
                }
            }.eraseToAnyPublisher()
    }
}
