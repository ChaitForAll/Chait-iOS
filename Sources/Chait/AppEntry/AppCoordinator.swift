//
//  AppCoordinator.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Supabase
import UIKit
import SwiftUI

final class AppCoordinator {
    
    // MARK: Property(s)
    
    let navigationController: UINavigationController = UINavigationController()
    
    private let client: SupabaseClient
    private let authService: AuthenticationService
    
    init(client: SupabaseClient) {
        self.client = client
        self.authService = AuthenticationService(supabase: client)
    }
    
    // MARK: Function(s)
    
    func prepareRoot() {
        if authService.isAuthenticated {
            toMainFlow()
        } else {
            toAuthenticationFlow()
        }
    }
    
    func toMainFlow() {
        navigationController.setViewControllers([createMainTabFlow()], animated: true)
    }
    
    func toAuthenticationFlow() {
        navigationController.setViewControllers([createAuthFlow()], animated: true)
    }
    
    func enterChannel(_ channelIdentifier: UUID) {
        navigationController.pushViewController(createPersonalChat(channelIdentifier), animated: true)
    }
    
    // MARK: Private Function(s)
    
    private func createMainTabFlow() -> UITabBarController {
        let tabViewController = UITabBarController()
        let friendList = createFriendsList()
        friendList.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.3.fill"), tag: 1)
        let channelList = createConversationListViewController()
        channelList.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message.fill"), tag: .zero)
        tabViewController.viewControllers = [friendList, channelList]
        return tabViewController
    }
    
    private func createFriendsList() -> FriendListViewController {
        let friendRepository = FriendRepositoryImplementation(client: client)
        let useCase = DefaultFetchFriendsListUseCase(repository: friendRepository)
        let viewModel = FriendListViewModel(
            userID: authService.userID ?? UUID(), /* TODO: Resolve optional */
            fetchFriendsListUseCase: useCase
        )
        let friendListViewController = FriendListViewController()
        friendListViewController.viewModel = viewModel
        return friendListViewController
    }
    
    private func createConversationListViewController() -> ConversationListViewController {
        let conversationUseCase = DefaultConversationUseCase(
            conversationRepository: ConversationRepositoryImplementation(
                conversationRemote: DefaultConversationRemoteDataSource(supabase: client),
                conversationMembershipRemote: DefaultConversationMembershipRemoteDataSource(supabase: client),
                userRemote: DefaultUserRemoteDataSource(supabase: client)
            ),
            userID: authService.userID ?? UUID() /* TODO: Resolve optional */
        )
        let viewModel = ConversationListViewModel(conversationUseCase: conversationUseCase)
        let channelListViewController = ConversationListViewController()
        channelListViewController.coordinator = self
        channelListViewController.viewModel = viewModel
        return channelListViewController
    }
    
    private func createPersonalChat(_ channelID: UUID) -> PersonalChatViewController {
        let remoteMessagesDataSource = DefaultRemoteMessagesDataSource(client: client)
        let chatRepository = DefaultChatRepository(remoteChatMessages: remoteMessagesDataSource)
        let sendMessageUseCase = DefaultSendMessageUseCase(repository: chatRepository)
        let fetchChatHistoryUseCase = DefaultFEtchChatHistoryUseCase(repository: chatRepository)
        let listenMessagesUseCase = DefaultListenMessagesUseCase(chatRepository: chatRepository)
        let personalChatVieWModel = PersonalChatViewModel(
            userID: authService.userID!,
            channelID: channelID,
            sendMessageUseCase: sendMessageUseCase,
            listenMessagesUseCase: listenMessagesUseCase,
            fetchChatHistoryUseCase: fetchChatHistoryUseCase
        )
        let personalChatViewController = PersonalChatViewController()
        personalChatViewController.viewModel = personalChatVieWModel
        return personalChatViewController
    }
    
    private func createAuthFlow() -> UIHostingController<AuthView> {
        let authViewModel = AuthViewModel(authService: authService)
        var authView = AuthView(viewModel: authViewModel)
        authView.delegate = self
        let authHostingViewController = UIHostingController(rootView: authView)
        return authHostingViewController
    }
}

// MARK: AuthenticationViewControllerDelegate

extension AppCoordinator: AuthenticationViewControllerDelegate {
    
    func authenticationSucceed() {
        toMainFlow()
    }
}
