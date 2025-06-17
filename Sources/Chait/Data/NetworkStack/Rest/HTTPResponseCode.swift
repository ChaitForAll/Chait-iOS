//
//  HTTPResponseCode.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

enum HTTPResponseCode {
    static let informationCodes = 100..<200
    static let successfulCodes = 200..<300
    static let redirectionCodes = 300..<400
    static let clientErrorCodes = 400..<500
    static let serverErrorCodes = 500..<600
}
