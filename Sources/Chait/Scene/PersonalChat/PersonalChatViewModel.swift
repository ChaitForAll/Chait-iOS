//
//  PersonalChatViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

final class PersonalChatViewModel {
    
    var userMessageText: String = ""
    
    private var cancelBag: Set<AnyCancellable> = .init()

    private let channelID: UUID
    
    init(channelID: UUID) {
        self.channelID = channelID
    }
}
