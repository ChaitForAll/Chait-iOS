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
    
    private let friendNavigation = UINavigationController()
    private let conversationNavigation = UINavigationController()
    private let appContainer: AppContainer = AppContainer()
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Function(s)
    
    func start() {
        let authService = appContainer.authService
        let windowRoot = authService.isAuthenticated ? createMainTabFlow() : onboardingFlow()
        window.rootViewController = windowRoot
        window.makeKeyAndVisible()
    }

    func enterChannel(_ channelIdentifier: UUID) {
        conversationNavigation.pushViewController(
            createPersonalChat(channelIdentifier),
            animated: true
        )
    }
    
    func toSingInFlow() {
        window.rootViewController = createSignInView()
    }
    
    func toMainTabFlow() {
        window.rootViewController = createMainTabFlow()
    }
    
    // MARK: Private Function(s)
    
    private func onboardingFlow() -> WelcomeViewController {
        let welcomeViewController = WelcomeViewController()
        welcomeViewController.coordinator = self
        return welcomeViewController
    }
    
    private func createMainTabFlow() -> UITabBarController {
        
        let friendList = createFriendsList()
        friendList.tabBarItem = UITabBarItem(
            title: "Friends",
            image: UIImage(systemName: "person.3.fill"),
            tag: 0
        )
        friendNavigation.setViewControllers([friendList], animated: true)
        friendNavigation.navigationBar.prefersLargeTitles = true
        
        let conversationList = createConversationListViewController()
        conversationList.tabBarItem = UITabBarItem(
            title: "Conversation",
            image: UIImage(systemName: "message.fill"),
            tag: 1
        )
        conversationNavigation.navigationBar.prefersLargeTitles = true
        conversationNavigation.setViewControllers([conversationList], animated: true)
        
        let tabViewController = UITabBarController()
        tabViewController.viewControllers = [friendNavigation, conversationNavigation]
        return tabViewController
    }
    
    private func createSignInView() -> SignInViewController {
        let signInViewController = SignInViewController()
        signInViewController.coordinator = self
        signInViewController.viewModel = appContainer.signInViewModel()
        return signInViewController
    }
    
    private func createFriendsList() -> FriendListViewController {
        let friendListViewController = FriendListViewController()
        friendListViewController.viewModel = appContainer.friendListViewModel()
        friendListViewController.navigationItem.title = "Friends"
        return friendListViewController
    }
    
    private func createConversationListViewController() -> ConversationListViewController {
        let channelListViewController = ConversationListViewController()
        channelListViewController.coordinator = self
        channelListViewController.viewModel = appContainer.conversationListViewModel()
        channelListViewController.navigationItem.title = "Conversation"
        return channelListViewController
    }
    
    private func createPersonalChat(_ channelID: UUID) -> ConversationViewController {
        let personalChatViewController = ConversationViewController()
        personalChatViewController.viewModel = appContainer.personalChatViewModel(channelID)
        return personalChatViewController
    }
}
