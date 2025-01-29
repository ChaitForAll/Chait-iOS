//
//  FetchChannelsUseCase.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Combine

enum FetchChannelsError: Error {
    case emptyChannelList
    case unknown
}

protocol FetchChannelsUseCase {
    func fetchAllChannels() -> AnyPublisher<[Channel], FetchChannelsError>
}
