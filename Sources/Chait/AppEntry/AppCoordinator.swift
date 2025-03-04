//
//  AppCoordinator.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Supabase
import UIKit

final class AppCoordinator {
    
    // MARK: Property(s)
    
    let navigationController: UINavigationController = UINavigationController()
    
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    // MARK: Function(s)
    
    func prepareRoot() {
        navigationController.pushViewController(createChannelList(), animated: false)
    }
    
    func enterChannel(_ channelIdentifier: UUID) {
        navigationController.pushViewController(createPersonalChat(channelIdentifier), animated: true)
    }
    
    // MARK: Private Function(s)
    
    private func createChannelList() -> ChannelListViewController {
        let defaultDataSource = DefaultRemoteChannelsDataSource(client: client)
        let defaultRepo = DefaultChannelRepository(dataSource: defaultDataSource)
        let channelsUseCaes = DefaultFetchChannelListUseCase(repository: defaultRepo)
        let viewModel = ChannelListViewModel(fetchChannelListUseCase: channelsUseCaes, userID: UUID(uuidString: "e22ffdc4-dddf-47cc-99e6-82cd56c7d415")!)
        let channelListViewController = ChannelListViewController()
        channelListViewController.coordinator = self
        channelListViewController.viewModel = viewModel
        return channelListViewController
    }
    
    private func createPersonalChat(_ channelID: UUID = UUID(uuidString: "5de13657-a02c-43f8-ac2a-636d268d80d5")!) -> PersonalChatViewController {
        let remoteMessagesDataSource = DefaultRemoteMessagesDataSource(client: client)
        let chatRepository = DefaultChatRepository(remoteChatMessages: remoteMessagesDataSource)
        let sendMessageUseCase = DefaultSendMessageUseCase(repository: chatRepository)
        let listenMessagesUseCase = DefaultListenMessagesUseCase(chatRepository: chatRepository)
        let personalChatVieWModel = PersonalChatViewModel(
            channelID: channelID,
            sendMessageUseCase: sendMessageUseCase,
            listenMessagesUseCase: listenMessagesUseCase
        )
        let personalChatViewController = PersonalChatViewController()
        personalChatViewController.viewModel = personalChatVieWModel
        print(client.realtimeV2.channels)
        
        // FIXME: UNSUBSCRIBE SHIT
        return personalChatViewController
    }
}
