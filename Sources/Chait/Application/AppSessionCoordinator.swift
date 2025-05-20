//
//  AppSessionCoordinator.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import Foundation
import Supabase
import UIKit
import SwiftUI

final class AppSessionCoordinator {
    
    // MARK: Property(s)
    
    private let friendNavigation = UINavigationController()
    private let conversationNavigation = UINavigationController()
    private let mainTabBarController = UITabBarController()
    
    private let window: UIWindow
    private let appSessionContainer: AppSessionContainer
    
    init(window: UIWindow, appSessionContainer: AppSessionContainer) {
        self.window = window
        self.appSessionContainer = appSessionContainer
        configureAppearances()
    }
    
    // MARK: Function(s)
    
    func start() {
        window.rootViewController = createMainTabFlow()
        window.makeKeyAndVisible()
    }

    func enterChannel(_ channelIdentifier: UUID) {
        conversationNavigation.pushViewController(
            createPersonalChat(channelIdentifier),
            animated: true
        )
    }
    
    // MARK: Private Function(s)
    
    private func configureAppearances() {
        let defaultNavigationAppearance = UINavigationBarAppearance()
        defaultNavigationAppearance.titlePositionAdjustment = .init(horizontal: -153, vertical: .zero)
        defaultNavigationAppearance.titleTextAttributes = [
            .font: UIFont.preferredFont(for: .title3, weight: .semibold)
        ]
        let defaultTabBarAppearance = UITabBarAppearance()
        friendNavigation.navigationBar.standardAppearance = defaultNavigationAppearance
        friendNavigation.navigationBar.scrollEdgeAppearance = defaultNavigationAppearance
        conversationNavigation.navigationBar.standardAppearance = defaultNavigationAppearance
        conversationNavigation.navigationBar.scrollEdgeAppearance = defaultNavigationAppearance
        mainTabBarController.tabBar.standardAppearance = defaultTabBarAppearance
        mainTabBarController.tabBar.scrollEdgeAppearance = defaultTabBarAppearance
    }
//    
//    private func onboardingFlow() -> WelcomeViewController {
//        let welcomeViewController = WelcomeViewController()
//        welcomeViewController.coordinator = self
//        return welcomeViewController
//    }
    
    private func createMainTabFlow() -> UITabBarController {
        
        let friendList = createFriendsList()
        friendList.tabBarItem = UITabBarItem(
            title: "Friends",
            image: UIImage(systemName: "person.3.fill"),
            tag: 0
        )
        friendNavigation.setViewControllers([friendList], animated: true)
//        friendNavigation.navigationBar.prefersLargeTitles = true
        
        let conversationList = createConversationListViewController()
        conversationList.tabBarItem = UITabBarItem(
            title: "Conversation",
            image: UIImage(systemName: "message.fill"),
            tag: 1
        )
//        conversationNavigation.navigationBar.prefersLargeTitles = true
        conversationNavigation.setViewControllers([conversationList], animated: true)
        
        mainTabBarController.viewControllers = [friendNavigation, conversationNavigation]
        return mainTabBarController
    }

    
    private func createFriendsList() -> FriendListViewController {
        let friendListViewController = FriendListViewController()
        friendListViewController.viewModel = appSessionContainer.friendListViewModel()
        friendListViewController.navigationItem.title = "Friends"
        return friendListViewController
    }
    
    private func createConversationListViewController() -> ConversationListViewController {
        let channelListViewController = ConversationListViewController()
        channelListViewController.coordinator = self
        channelListViewController.viewModel = appSessionContainer.conversationListViewModel()
        channelListViewController.navigationItem.title = "Conversation"
        return channelListViewController
    }
    
    private func createPersonalChat(_ channelID: UUID) -> ConversationViewController {
        let personalChatViewController = ConversationViewController()
        personalChatViewController.viewModel = appSessionContainer.personalChatViewModel(channelID)
        personalChatViewController.hidesBottomBarWhenPushed = true
        return personalChatViewController
    }
}
