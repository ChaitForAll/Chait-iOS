//
//  ChannelListViewModel.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.


import Foundation
import Combine

final class ChannelListViewModel {
    
    // MARK: Property(s)
    
    let fetchedChannels: PassthroughSubject<[ChannelPresentationModel.ID], Never> = .init()
    let removedChannels: PassthroughSubject<[ChannelPresentationModel.ID], Never> = .init()
    
    private var channels: [ChannelPresentationModel.ID : ChannelPresentationModel] = [:]
    private var cancelBag: Set<AnyCancellable> = .init()
    
    private let fetchChannelsUseCase: FetchChannelsUseCase
    private let createNewChannelUseCase: CreateNewChannelUseCase
    private let listenChannelUpdateUseCase: ListenChannelsUpdateUseCase
    
    init(
        fetchChannelsUseCase: FetchChannelsUseCase,
        createNewChannelUseCase: CreateNewChannelUseCase,
        listenChannelUpdateUseCase: ListenChannelsUpdateUseCase
    ) {
        self.fetchChannelsUseCase = fetchChannelsUseCase
        self.createNewChannelUseCase = createNewChannelUseCase
        self.listenChannelUpdateUseCase = listenChannelUpdateUseCase
    }
    
    // MARK: Function(s)
    
    func startListeningChannelUpdates() {
        listenChannelUpdateUseCase.execute()
            .sink(
                receiveCompletion: { _ in } ,
                receiveValue: { channelUpdate in
                    switch channelUpdate.channelUpdateState {
                    case .inserted:
                        let insertedChannel = ChannelPresentationModel(
                            id: channelUpdate.updatedChannel.id,
                            title: channelUpdate.updatedChannel.title
                        )
                        self.channels[insertedChannel.id] = insertedChannel
                        self.fetchedChannels.send([insertedChannel.id])
                    case .deleted:
                        self.channels.removeValue(forKey: channelUpdate.updatedChannel.id)
                        self.removedChannels.send([channelUpdate.updatedChannel.id])
                    case .updated: return
                    }
                }
            ).store(in: &cancelBag)
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
            ).store(in: &cancelBag)
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
