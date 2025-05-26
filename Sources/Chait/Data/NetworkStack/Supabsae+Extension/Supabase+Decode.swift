//
//  Supabase+Decode.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Supabase
import Foundation

extension PostgrestResponse {
    func decodeJSON<ResponseType: Decodable>() throws -> ResponseType {
        return try SnakeKeyISODateJSONDecoder().decode(ResponseType.self, from: data)
    }
}
