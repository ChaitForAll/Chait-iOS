//
//  ChannelListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Combine

final class ChannelListViewModel {
    
    let fetchedChannels: PassthroughSubject<[ChannelPresentationModel.ID], Never> = .init()
    
    private var channels: [ChannelPresentationModel.ID : ChannelPresentationModel] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let fetchChannelsUseCase: FetchChannelsUseCase
    private let createNewChannelUseCase: CreateNewChannelUseCase
    
    init(fetchChannelsUseCase: FetchChannelsUseCase, createNewChannelUseCase: CreateNewChannelUseCase) {
        self.fetchChannelsUseCase = fetchChannelsUseCase
        self.createNewChannelUseCase = createNewChannelUseCase
    }
    
    func prepareChannels() {
        fetchChannelsUseCase.fetchAllChannels()
            .map { channels -> [ChannelPresentationModel] in
                return channels.map { channel in
                    return ChannelPresentationModel(id: channel.id, title: channel.title)
                }
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { receivedChannels in
                    receivedChannels.forEach { self.channels[$0.id] = $0 }
                    self.fetchedChannels.send(receivedChannels.map { $0.id })
                }
            )
            .store(in: &cancelBag)
    }
    
    func channel(for channelID: ChannelPresentationModel.ID) -> ChannelPresentationModel? {
        return self.channels[channelID]
    }
    
    func createNewChannel(_ title: String, _ failure: @escaping (String) -> Void) {
        createNewChannelUseCase.create(newChannel: NewChannel(title: title))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion,
                   case .invalidInput(let message) = error {
                    failure(message)
                }
            } receiveValue: { }
            .store(in: &cancelBag)
    }
}
