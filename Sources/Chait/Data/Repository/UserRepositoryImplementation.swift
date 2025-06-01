//
//  UserRepositoryImplementation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine
import Foundation

final class UserRepositoryImplementation: UserRepository {
    
    private let userDataSource: UserRemoteDataSource
    private let authSession: AuthSession
    
    init(userDataSource: UserRemoteDataSource, authSession: AuthSession) {
        self.userDataSource = userDataSource
        self.authSession = authSession
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
    
    func fetchAppUser() async throws -> AppUser {
        let userResponse = try await userDataSource.fetchUser(authSession.currentUserID)
        return AppUser(
            displayName: userResponse.displayName,
            id: userResponse.id,
            userName: userResponse.name,
            createdAt: userResponse.createdAt,
            profileImage: ProfileImage(imageURL: userResponse.profileImage)
        )
    }
}
