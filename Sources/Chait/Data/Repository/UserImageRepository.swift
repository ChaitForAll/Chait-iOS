//
//  ProfileImageDataRepository.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine
import Supabase

final class UserImageRepository: FetchUserImageDataPort {
    
    // MARK: Property(s)
    
    private let supabase: SupabaseClient
    private let staleWhileRevalidateSession: StaleWhileRevalidateSession
    
    init(supabase: SupabaseClient, staleWhileRevalidateSession: StaleWhileRevalidateSession) {
        self.supabase = supabase
        self.staleWhileRevalidateSession = staleWhileRevalidateSession
    }
    
    // MARK: Function(s)
    
    func fetchImageData(
        _ command: FetchUserImageCommand
    ) -> AnyPublisher<UserImage, FetchUserImageDataPortError> {
        Future<UserImageResponse, FetchUserImageDataPortError> { promise in
            Task {
                do {
                    let response: UserImageResponse = try await self.supabase
                        .from("user_profile_image")
                        .select()
                        .eq("user_id", value: command.userID)
                        .single()
                        .execute()
                        .value
                    promise(.success(response))
                } catch {
                    promise(.failure(.failed))
                }
            }
        }.flatMap { response in
            return self.staleWhileRevalidateSession
                .requestDataPublisher(from: response.imageURL)
                .mapError { staleWhileRevalidateError in
                    switch staleWhileRevalidateError {
                    case .failed, .notFound:
                        return .failed
                    case .unknown:
                        return .unknown
                    }
                }
                .map { UserImage(data: $0, imageType: .profile) }
                .eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
