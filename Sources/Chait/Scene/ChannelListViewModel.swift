//
//  ChannelListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

final class ChannelListViewModel {
    
    let fetchedChannels: PassthroughSubject<[ChannelPresentationModel.ID], Never> = .init()
    
    private let fetchChannelsUseCase: FetchChannelsUseCase
    
    init(fetchChannelsUseCase: FetchChannelsUseCase) {
        self.fetchChannelsUseCase = fetchChannelsUseCase
    }
}
