//
//  SceneDelegate.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        let navigationController = ASNavigationController(rootViewController: MainViewController())
        navigationController.navigationBar.isTranslucent = false
        window.rootViewController = navigationController
        self.window = window
    }
}
