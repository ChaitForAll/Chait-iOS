//
//  UserRepositoryImplementation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine
import Foundation

final class UserRepositoryImplementation: UserRepository {
    
    private let userDataSource: UserRemoteDataSource
    
    init(userDataSource: UserRemoteDataSource) {
        self.userDataSource = userDataSource
    }
    
    func fetchUserDetails(_ userIdentifiers: [UUID]) async throws -> [UserDetail] {
        let userResponses = try await self.userDataSource.fetchUsers(userIdentifiers)
        let userDetails = userResponses.map {
            UserDetail(
                id: $0.id,
                userName: $0.displayName,
                profileImage: $0.profileImage.formatted()
            )
        }
        return userDetails
    }
}
