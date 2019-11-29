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
        
        self.setupTheme(window: window)
        self.setupNavigationAppearance()
        self.window = window
        return true
    }
    
    private func setupNavigationAppearance() {
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
    
    private func setupTheme(window: UIWindow) {
        if !StorageManager.fileExists(StorageKeys.theme, in: .caches) {
            if #available(iOS 13.0, *) {
                let theme = window.traitCollection.userInterfaceStyle
                Theme.current = theme == .dark ? DarkTheme() : LightTheme()
            } else {
                Theme.current = LightTheme()
            }
        } else {
            let theme = StorageManager.retrieve(StorageKeys.theme, from: .caches, as: String.self)
            if theme == ThemeMode.dark.description {
                Theme.current = DarkTheme()
            } else {
                Theme.current = LightTheme()
            }
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        if !BusManager.didFetchAll {
            StorageManager.remove(StorageKeys.season, from: .caches)
            StorageManager.remove(StorageKeys.urbanLines, from: .caches)
            StorageManager.remove(StorageKeys.suburbanLines, from: .caches)
        }
    }
}

