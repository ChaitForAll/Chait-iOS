//
//  AppCoreCoordinator.swift
//  Chait
//
//  Copyright (c) 2025 Jeremy All rights reserved.
    

import UIKit

final class AppCoreCoordinator {
    
    // MARK: Property(s)
    
    private let window: UIWindow
    private let appCoreContainer = AppCoreContainer()
    private let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
        self.appCoreContainer.authService.delegate = self
    }
    
    // MARK: Function(s)
    
    func start() {
        navigationController.setViewControllers([createWelcomeViewController()], animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func signInFlow() {
        navigationController.pushViewController(createSignInViewController(), animated: true)
    }
    
    // MARK: Private FunctioN(s)
    
    private func createWelcomeViewController() -> WelcomeViewController {
        let welcomeViewController = WelcomeViewController()
        welcomeViewController.coordinator = self
        return welcomeViewController

    }
    
    private func createSignInViewController() -> SignInViewController {
        let signInViewController = SignInViewController()
        signInViewController.viewModel = appCoreContainer.createSignInViewModel()
        return signInViewController
    }
}

// MARK: AuthenticationServiceDelegate

extension AppCoreCoordinator: AuthenticationServiceDelegate {
    
    func authenticationComplete(with session: AuthSession) {
        DispatchQueue.main.async {
            let appCoordinator = AppSessionCoordinator(
                window: self.window,
                appSessionContainer: AppSessionContainer(
                    client: self.appCoreContainer.supabaseClient,
                    authSession: session
                )
            )
            appCoordinator.start()
        }
    }
}
