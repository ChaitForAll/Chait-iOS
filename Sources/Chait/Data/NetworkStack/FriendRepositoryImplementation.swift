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
    
    func fetchFriendList(userID: UUID) -> AnyPublisher<[Friend], FetchFriendsListError> {
        return Future<[Friend], FetchFriendsListError> { promise in
            Task {
                do {
                    let friendsResponse = try await self.asyncFetchFriendshipResponse(userID)
                        .map { $0.userID == userID ? $0.friendID : $0.userID }
                    let users = try await self.usersRemote.fetchUsers(friendsResponse)
                    let friendsList = users.map { user in
                        return Friend(
                            friendID: user.id,
                            name: user.name,
                            displayName: user.displayName,
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
    
    private func asyncFetchFriendshipResponse(_ userID: UUID) async throws -> [FriendResponse] {
        try await client
            .from("friend_relations")
            .select()
            .or("userID.eq.\(userID),friendID.eq.\(userID)")
            .execute()
            .value
    }
}
