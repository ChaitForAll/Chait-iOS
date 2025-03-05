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
        let window = UIWindow(windowScene: windowScene)
        let coordinator = AppCoordinator(client: client)
        coordinator.prepareRoot()
        window.rootViewController = coordinator.navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
