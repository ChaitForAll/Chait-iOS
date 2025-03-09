//
//  ChannelMembershipResponseBuilder.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
@testable import Chait
import Foundation

final class ChannelMembershipResponseBuilder {
    
    private var userIdentifier: UUID = .init()
    private var channelIdentifier: UUID = .init()
    
    func withIdentifier(_ identifier: UUID) -> Self {
        self.userIdentifier = identifier
        return self
    }
    
    func withChannelIdentifier(_ identifier: UUID) -> Self {
        self.channelIdentifier = identifier
        return self
    }
    
    func build() -> ChannelMembershipResponse {
        return ChannelMembershipResponse(
            userID: userIdentifier,
            channelID: channelIdentifier
        )
    }
    
    func buildExactly(_ count: Int) -> [ChannelMembershipResponse] {
        return (0..<count).map { _ in build() }
    }
}
