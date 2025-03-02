//
//  MockFetchChannelListSuccess.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

@testable import Chait
import Foundation
import Combine

final class StubFetchChannelListSuccess: ChannelRepository {
    
    let channels: [Channel]
    
    init(channels: [Channel]) {
        self.channels = channels
    }
    
    func fetchChannels(userID: UUID) -> AnyPublisher<[Channel], FetchChannelListUseCaseError> {
        return Just(channels)
            .setFailureType(to: FetchChannelListUseCaseError.self)
            .eraseToAnyPublisher()
    }
}
