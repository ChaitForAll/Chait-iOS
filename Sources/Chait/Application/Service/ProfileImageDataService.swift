//
//  ProfileImageDataService.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation
import UIKit

enum ProfileImageDataServiceError: Error {
    case failedFetchingData
    case notFound
    case unknown
}

struct ProfileImageDataService {
    
    // MARK: Property(s)
    
    private let fetchImageMetaPort: FetchImageMetaPort
    private let fetchImageDataPort: FetchImageDataPort
    
    init(fetchImageMetaPort: FetchImageMetaPort, fetchImageDataPort: FetchImageDataPort) {
        self.fetchImageMetaPort = fetchImageMetaPort
        self.fetchImageDataPort = fetchImageDataPort
    }
    
    // MARK: Function(s)
    
    func fetchImageData(for userID: UUID) async throws -> Data {
        do {
            let userImageMeta = try await fetchImageMetaPort.fetch(for: userID)
            let userImageData = try await fetchImageDataPort.fetchImageData(
                for: userImageMeta.sourceURL
            )
            return userImageData
        } catch let error as FetchImageMetaPortError {
            switch error {
            case .unknown:
                throw ProfileImageDataServiceError.unknown
            case .notFound:
                throw ProfileImageDataServiceError.notFound
            }
        } catch let error as FetchImageDataPortError {
            switch error {
            case .unknown:
                throw ProfileImageDataServiceError.unknown
            case .failed:
                throw ProfileImageDataServiceError.failedFetchingData
            }
        }
    }
}
