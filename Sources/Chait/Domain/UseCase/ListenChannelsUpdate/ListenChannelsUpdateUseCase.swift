//
//  ListenChannelsUpdateUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Combine

enum ListenChannelsUpdateError: Error {
    case unknown
}

protocol ListenChannelsUpdateUseCase {
    func execute() -> AnyPublisher<ChannelUpdate, ListenChannelsUpdateError>
}
