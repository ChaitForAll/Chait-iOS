//
//  StaleWhileRevalidateSession.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

enum StaleWhileRevalidateSessionError: Error {
    case failed
    case notFound
    case unknown
}

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
    
    func requestDataPublisher(from url: URL) -> AnyPublisher<Data, StaleWhileRevalidateSessionError> {
        let request = URLRequest(url: url)
        let freshPublisher: AnyPublisher<Data, StaleWhileRevalidateSessionError> = Deferred {
            session.dataTaskPublisher(for: url)
                .handleEvents(receiveOutput: { data, response in
                    let toCache = CachedURLResponse(response: response, data: data)
                    urlCache.storeCachedResponse(toCache, for: request)
                })
                .map(\.data)
                .mapError { _ in
                    return StaleWhileRevalidateSessionError.failed
                }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
        
        if let cached = urlCache.cachedResponse(for: request) {
            return Just(cached.data)
                .setFailureType(to: StaleWhileRevalidateSessionError.self)
                .append(freshPublisher)
                .eraseToAnyPublisher()
        } else {
            return Empty()
                .setFailureType(to: StaleWhileRevalidateSessionError.self)
                .append(freshPublisher)
                .eraseToAnyPublisher()
        }
    }
    
    func requestDataStream(from url: URL) -> AsyncThrowingStream<Data, Error> {
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
