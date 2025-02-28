//
//  SceneDelegate.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit
import Supabase

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Property(s)
    
    private var client: SupabaseClient = SupabaseClient(
        supabaseURL: AppEnvironment.projectURL,
        supabaseKey: AppEnvironment.secretKey
    )

    var window: UIWindow?
    
    // MARK: Function(s)

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let remoteMessagesDataSource = DefaultRemoteMessagesDataSource(client: client)
        let chatRepository = DefaultChatRepository(remoteChatMessages: remoteMessagesDataSource)
        let sendMessageUseCase = DefaultSendMessageUseCase(repository: chatRepository)
        let listenMessagesUseCase = DefaultListenMessagesUseCase(chatRepository: chatRepository)
        let personalChatVieWModel = PersonalChatViewModel(
            channelID: UUID(uuidString: "5de13657-a02c-43f8-ac2a-636d268d80d5")!,
            sendMessageUseCase: sendMessageUseCase,
            listenMessagesUseCase: listenMessagesUseCase
        )
        let personalChatViewController = PersonalChatViewController()
        personalChatViewController.viewModel = personalChatVieWModel
        let navigationViewController = UINavigationController(rootViewController: personalChatViewController)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
