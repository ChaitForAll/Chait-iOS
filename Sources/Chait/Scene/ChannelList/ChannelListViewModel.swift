//
//  ChannelListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

final class ChannelListViewModel {
    
    private let fetchChannelListUseCase: FetchChannelListUseCase
    private let userID: UUID
    
    init(fetchChannelListUseCase: FetchChannelListUseCase, userID: UUID) {
        self.fetchChannelListUseCase = fetchChannelListUseCase
        self.userID = userID
    }
}
