//
//  FetchImageDataPort.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

protocol FetchImageDataPort {
    func fetchImageData(for url: URL) async throws -> Data
}
