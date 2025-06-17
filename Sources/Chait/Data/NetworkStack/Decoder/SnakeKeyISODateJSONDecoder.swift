//
//  SnakeKeyISODateJSONFormatter.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

final class SnakeKeyISODateJSONDecoder: JSONDecoder, @unchecked Sendable {
    
    override init() {
        super.init()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        self.keyDecodingStrategy = .convertFromSnakeCase
        self.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            guard let date = isoFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid ISO 8601 date: \(dateString)"
                )
            }
            
            return date
        }
    }
}
