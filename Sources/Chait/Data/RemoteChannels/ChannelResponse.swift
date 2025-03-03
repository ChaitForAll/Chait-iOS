//
//  ChannelResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct ChannelResponse: Decodable {
    let title: String
    let channelID: UUID
    let createdAt: String
}
