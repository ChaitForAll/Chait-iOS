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
    
    private let navigationController: UINavigationController = UINavigationController()
    private let appContainer: AppContainer = AppContainer()
    
    // MARK: Function(s)
    
    func start(on window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        if appContainer.authService.isAuthenticated {
            toMainFlow()
        } else {
            toAuthenticationFlow()
        }
    }

    func enterChannel(_ channelIdentifier: UUID) {
        navigationController.pushViewController(
            createPersonalChat(channelIdentifier),
            animated: true
        )
    }
    
    // MARK: Private Function(s)
    
    private func toMainFlow() {
        navigationController.setViewControllers([createMainTabFlow()], animated: true)
    }
    
    private func toAuthenticationFlow() {
        navigationController.setViewControllers([createAuthFlow()], animated: true)
    }
    
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
        let friendListViewController = FriendListViewController()
        friendListViewController.viewModel = appContainer.friendListViewModel()
        return friendListViewController
    }
    
    private func createConversationListViewController() -> ConversationListViewController {
        let channelListViewController = ConversationListViewController()
        channelListViewController.coordinator = self
        channelListViewController.viewModel = appContainer.conversationListViewModel()
        return channelListViewController
    }
    
    private func createPersonalChat(_ channelID: UUID) -> PersonalChatViewController {
        let personalChatViewController = PersonalChatViewController()
        personalChatViewController.viewModel = appContainer.personalChatViewModel(channelID)
        return personalChatViewController
    }
    
    private func createAuthFlow() -> UIHostingController<AuthView> {
        var authView = AuthView(viewModel: appContainer.authViewModel())
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
