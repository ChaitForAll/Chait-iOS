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
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    // MARK: Function(s)
    
    func fetchFriendList(userID: UUID) -> AnyPublisher<[Friend], FetchFriendsListError> {
        return Future<[Friend], FetchFriendsListError> { promise in
            Task {
                do {
                    let friendsResponse = try await self.asyncFetchFriendshipResponse(userID)
                    let friendsList = friendsResponse.map {
                        let friendID = $0.friendID == userID ? $0.userID : $0.friendID
                        return Friend(friendID: friendID, createdAt: $0.created_at)
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
