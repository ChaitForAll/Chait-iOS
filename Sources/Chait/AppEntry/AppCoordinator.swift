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
        navigationController.pushViewController(createMainTabFlow(), animated: false)
    }
    
    func enterChannel(_ channelIdentifier: UUID) {
        navigationController.pushViewController(createPersonalChat(channelIdentifier), animated: true)
    }
    
    // MARK: Private Function(s)
    
    private func createMainTabFlow() -> UITabBarController {
        let tabViewController = UITabBarController()
        let channelList = createChannelList()
        channelList.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message.fill"), tag: .zero)
        tabViewController.viewControllers = [channelList]
        return tabViewController
    }
    
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
        let fetchChatHistoryUseCase = DefaultFEtchChatHistoryUseCase(repository: chatRepository)
        let listenMessagesUseCase = DefaultListenMessagesUseCase(chatRepository: chatRepository)
        let personalChatVieWModel = PersonalChatViewModel(
            userID: UUID(uuidString: "e22ffdc4-dddf-47cc-99e6-82cd56c7d415")!,
            channelID: channelID,
            sendMessageUseCase: sendMessageUseCase,
            listenMessagesUseCase: listenMessagesUseCase,
            fetchChatHistoryUseCase: fetchChatHistoryUseCase
        )
        let personalChatViewController = PersonalChatViewController()
        personalChatViewController.viewModel = personalChatVieWModel
        return personalChatViewController
    }
}
