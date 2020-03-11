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
        if !StorageManager.isThemeAlreadyCached {
            if #available(iOS 13.0, *) {
                let theme = window.traitCollection.userInterfaceStyle
                Theme.current = theme == .dark ? DarkTheme() : LightTheme()
            } else {
                Theme.current = LightTheme()
            }
        } else {
            let theme = StorageManager.retrieveTheme()
            if theme == ThemeMode.dark.description {
                Theme.current = DarkTheme()
            } else {
                Theme.current = LightTheme()
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if !StorageManager.fileExists(StorageKeys.urbanLines, in: .caches) || !StorageManager.fileExists(StorageKeys.suburbanLines, in: .caches) {
            StorageManager.remove(StorageKeys.season, from: .caches)
            return
        }
        let urbanLines = StorageManager.retrieve(StorageKeys.urbanLines, from: .caches, as: [Line].self)
        let suburbanLines = StorageManager.retrieve(StorageKeys.suburbanLines, from: .caches, as: [Line].self)
        for line in urbanLines {
            if !StorageManager.fileExists(StorageKeys.bus + line.id, in: .caches) {
                StorageManager.remove(StorageKeys.season, from: .caches)
                return
            }
        }
        for line in suburbanLines {
            if !StorageManager.fileExists(StorageKeys.bus + line.id, in: .caches) {
                StorageManager.remove(StorageKeys.season, from: .caches)
                return
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //get main vc as currently active vc and refresh current hour and day
    }
}

