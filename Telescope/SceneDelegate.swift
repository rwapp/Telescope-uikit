//
//  SceneDelegate.swift
//  Telescope
//
//  Created by Rob Whitaker on 26/04/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            let navController = UINavigationController(rootViewController: SearchViewController())
            navController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
            navController.title = "Telescope"

            let tabController = UITabBarController()
            tabController.viewControllers = [navController]

            window.rootViewController = tabController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
