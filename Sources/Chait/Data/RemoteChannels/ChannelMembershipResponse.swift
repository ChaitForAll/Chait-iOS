//
//  ChannelMembershipResponse.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation

struct ChannelMembershipResponse: Decodable {
    let userID: UUID
    let channelID: UUID
}
