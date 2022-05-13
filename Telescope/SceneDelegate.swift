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

            let searchNavController = UINavigationController(rootViewController: SearchViewController())
            searchNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

            let favNavController = UINavigationController(rootViewController: FavouritesViewController())
            favNavController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

            let tabController = UITabBarController()
            tabController.viewControllers = [searchNavController, favNavController]

            window.rootViewController = tabController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
