//
//  FetchImageMetaPort.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

enum FetchImageMetaPortError: Error {
    case unknown
    case notFound
}

protocol FetchImageMetaPort {
    func fetch(for userID: UUID) async throws -> ImageMeta
}
