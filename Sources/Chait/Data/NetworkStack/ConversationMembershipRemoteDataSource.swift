//
//  ConversationMembershipRemoteDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    
import Foundation

protocol ConversationMembershipRemoteDataSource {
    func fetchConversationMemberships(_ userID: UUID) async throws -> [ConversationMembershipResponse]
}
