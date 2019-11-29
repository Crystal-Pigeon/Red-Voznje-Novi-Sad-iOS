//
//  AppDelegate.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        
        BusManager.retriveFavorites()
        
        let navigationController = ASNavigationController(rootViewController: MainViewController())
        navigationController.navigationBar.isTranslucent = false
        window.rootViewController = navigationController
        
        self.setupTheme()
        self.setupNavigationAppearance()
        self.window = window
        return true
    }
    
    func setupNavigationAppearance() {
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = Theme.current.color(.navigationTintColor)
        navigationBarAppearace.barTintColor = Theme.current.color(.navigationBackgroundColor)
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.titleTextAttributes = [
            .foregroundColor: Theme.current.color(.navigationTintColor),
            .font: Fonts.muliSemiBold20
        ]
    }
    
    func setupTheme() {
        if !StorageManager.fileExists(StorageKeys.theme, in: .caches) {
            StorageManager.store("Light", to: .caches, as: StorageKeys.theme)
        }
        let theme = StorageManager.retrieve(StorageKeys.theme, from: .caches, as: String.self)
        if theme == "Light" {
            Theme.current = LightTheme()
        } else {
            Theme.current = DarkTheme()
        }
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        StorageManager.store(Theme.current.mode.description, to: .caches, as: StorageKeys.theme)
    }
}

