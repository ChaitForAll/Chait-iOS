//
//  StaleWhileRevalidateSession.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation

struct StaleWhileRevalidateSession {
    
    // MARK: Property(s)
    
    private let urlCache: URLCache
    private let session: URLSession
    
    init() {
        let noCacheConfiguration = URLSessionConfiguration.ephemeral
        noCacheConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        noCacheConfiguration.urlCache = nil
        self.urlCache = URLCache()
        self.session = URLSession(configuration: noCacheConfiguration)
    }
    
    // MARK: Function(s)
    
    func requestData(from url: URL) -> AsyncThrowingStream<Data, Error> {
        return AsyncThrowingStream<Data, Error> { continuation in
            
            let request = URLRequest(url: url)
            
            if let cached = urlCache.cachedResponse(for: request) {
                continuation.yield(cached.data)
            }
            
            Task {
                let (data, response) = try await loadFresh(from: url)
                if let response = response as? HTTPURLResponse,
                   HTTPResponseCode.successfulCodes ~= response.statusCode {
                    continuation.yield(data)
                    continuation.finish()
                } else {
                    continuation.finish(throwing: RestError.notFound)
                }
            }
        }
    }
    
    private func loadFresh(from url: URL) async throws -> (Data, URLResponse) {
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedResponse, for: request)
        return (data, response)
    }
}
