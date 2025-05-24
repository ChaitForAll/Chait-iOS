//
//  UserRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

enum UserRepositoryError: Error {
    case unknown
}

protocol UserRepository {
    func fetchUserDetails(_ userIdentifiers: [UUID]) async throws -> [UserDetail]
}
