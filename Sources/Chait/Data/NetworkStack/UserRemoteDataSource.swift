//
//  UserRemoteDataSource.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.

import Foundation

protocol UserRemoteDataSource {
    func fetchUser(_ userIdentifier: UUID) async throws -> UserResponse
    func fetchUsers(_ userIdentifiers: [UUID]) async throws -> [UserResponse]
}
