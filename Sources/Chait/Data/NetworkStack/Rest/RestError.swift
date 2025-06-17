//
//  RestError.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

enum RestError: Error {
    case unknown
    case notFound
    case unauthorized
    case invalidResponse
    case lostInternetConnection
    case decodingFailed
}
