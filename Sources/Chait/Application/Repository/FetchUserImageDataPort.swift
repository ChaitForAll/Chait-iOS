//
//  FetchImageDataPort.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum FetchUserImageDataPortError: Error {
    case unknown
    case failed
}

protocol FetchUserImageDataPort {
    func fetchImageData(
        _ command: FetchUserImageCommand
    ) -> AnyPublisher<UserImage, FetchUserImageDataPortError>
}
