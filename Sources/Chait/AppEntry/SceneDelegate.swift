//
//  SceneDelegate.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Property(s)

    var window: UIWindow?
    
    // MARK: Function(s)

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let channelRepository = DefaultChannelRepository()
        let useCase = DefaultFetchChannelsUseCase(channelsRepository: channelRepository);
        let createUseCase = DefaultCreateNewChannelUseCase(repository: channelRepository)
        let viewModel = ChannelListViewModel(fetchChannelsUseCase: useCase, createNewChannelUseCase: createUseCase)
        let channelListViewController = ChannelListViewController()
        channelListViewController.viewModel = viewModel
        channelListViewController.tabBarItem = UITabBarItem(
            title: "Chat",
            image: UIImage(systemName: "bubble.left.and.text.bubble.right"),
            selectedImage: UIImage(systemName: "bubble.left.and.text.bubble.right.fill")
        )
        
        let tabViewController = UITabBarController()
        tabViewController.viewControllers = [channelListViewController]
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: tabViewController)
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

final class AnotherViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .systemBackground
        tabBarController?.navigationItem.title = "Anothers"
    }
}
