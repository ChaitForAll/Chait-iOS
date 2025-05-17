//
//  FriendRepositoryImplementation.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine
import Supabase
import Foundation

final class FriendRepositoryImplementation: FriendRepository {
    
    // MARK: Property(s)
    
    private let client: SupabaseClient
    private let usersRemote: UserRemoteDataSource
    
    init(client: SupabaseClient, usersRemote: UserRemoteDataSource) {
        self.client = client
        self.usersRemote = usersRemote
    }
    
    // MARK: Function(s)
    
    func fetchFriendList() -> AnyPublisher<[Friend], FetchFriendsListError> {
        
        guard let userID = self.client.auth.currentSession?.user.id else {
            return Fail(error: FetchFriendsListError.unknown).eraseToAnyPublisher()
        }
        
        return Future<[Friend], FetchFriendsListError> { promise in
            Task {
                do {
                    let friendsResponse = try await self.asyncFetchFriendshipResponse()
                        .map { $0.userID == userID ? $0.friendID : $0.userID }
                    let users = try await self.usersRemote.fetchUsers(friendsResponse)
                    let friendsList = users.map { user in
                        return Friend(
                            friendID: user.id,
                            name: user.name,
                            displayName: user.displayName,
                            status: user.status,
                            createdAt: user.createdAt,
                            image: user.profileImage
                        )
                    }
                    promise(.success(friendsList))
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: Private Function(s)
    
    enum AuthenticationError: Error {
        case notAuthenticated
    }
    
    private func asyncFetchFriendshipResponse() async throws -> [FriendResponse] {
        
        guard let userID = client.auth.currentSession?.user.id else {
            throw AuthError.sessionMissing
        }
        
        return try await client
            .from("friend_relations")
            .select()
            .or("userID.eq.\(userID),friendID.eq.\(userID)")
            .execute()
            .value
    }
}
