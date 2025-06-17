//
//  FetchImageDataPort.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

enum FetchImageDataPortError: Error {
    case unknown
    case failed
}

protocol FetchImageDataPort {
    func fetchImageData(for url: URL) async throws -> Data
}
