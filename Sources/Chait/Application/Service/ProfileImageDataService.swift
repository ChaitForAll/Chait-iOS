//
//  ProfileImageDataService.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import Combine

enum ProfileImageDataServiceError: Error {
    case failed
    case unknown
}

struct ProfileImageDataService {
    
    // MARK: Property(s)
    
    private let fetchImageDataPort: FetchUserImageDataPort
    
    init(fetchImageDataPort: FetchUserImageDataPort) {
        self.fetchImageDataPort = fetchImageDataPort
    }
    
    // MARK: Function(s)
    
    func fetchImageData(
        _ command: FetchUserImageCommand
    ) -> AnyPublisher<UserImage, ProfileImageDataServiceError> {
        return fetchImageDataPort.fetchImageData(command)
            .mapError { fetchImageDataPortError in
                print(fetchImageDataPortError)
                switch fetchImageDataPortError {
                case .unknown:
                    return .unknown
                case .failed:
                    return .failed
                }
            }.eraseToAnyPublisher()
    }
}
