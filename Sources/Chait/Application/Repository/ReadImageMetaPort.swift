//
//  ReadImageMetaPort.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

protocol ReadImageMetaPort {
    func read(for userID: UUID) async throws -> ImageMeta
}
