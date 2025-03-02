//
//  StubFetchChannelFails.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation
import Combine

final class StubFetchChannelFails: ChannelRepository {
    
    let error :FetchChannelListUseCaseError
    
    init(error: FetchChannelListUseCaseError) {
        self.error = error
    }
    
    func fetchChannels(userID: UUID) -> AnyPublisher<[Channel], FetchChannelListUseCaseError> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}
