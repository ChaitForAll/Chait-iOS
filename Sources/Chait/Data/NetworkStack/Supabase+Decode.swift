//
//  Supabase+Decode.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Supabase
import Foundation

extension PostgrestResponse {
    
    func decode<ResponseType: Decodable>(
        using decodingStrategy: JSONDecoder.KeyDecodingStrategy
    ) throws -> ResponseType {
        let snakeCaseDecoder = JSONDecoder()
        snakeCaseDecoder.keyDecodingStrategy = decodingStrategy
        return try snakeCaseDecoder.decode(ResponseType.self, from: data)
    }
}
