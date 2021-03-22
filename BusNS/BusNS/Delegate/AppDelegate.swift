//
//  AppDelegate.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
        // Short-circuit starting app if running unit tests
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isUnitTesting else {
          return true
        }
        #endif
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        
        FirebaseApp.configure()
        
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
        if !StorageManager.shared.isThemeAlreadyCached {
            let theme = window.traitCollection.userInterfaceStyle
            Theme.current = theme == .dark ? DarkTheme() : LightTheme()
        } else {
            let theme = StorageManager.shared.retrieveTheme()
            if theme == ThemeMode.dark.description {
                Theme.current = DarkTheme()
            } else if theme == ThemeMode.light.description{
                Theme.current = LightTheme()
            } else {
                let theme = UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle
                Theme.current = theme == .dark ? DarkTheme() : LightTheme()
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if !StorageManager.shared.fileExists(StorageKeys.urbanLines, in: .caches) || !StorageManager.shared.fileExists(StorageKeys.suburbanLines, in: .caches) {
            StorageManager.shared.remove(StorageKeys.season, from: .caches)
            return
        }
        let urbanLines = StorageManager.shared.retrieve(StorageKeys.urbanLines, from: .caches, as: [Line].self)
        let suburbanLines = StorageManager.shared.retrieve(StorageKeys.suburbanLines, from: .caches, as: [Line].self)
        for line in urbanLines {
            if !StorageManager.shared.fileExists(StorageKeys.bus + line.id, in: .caches) {
                StorageManager.shared.remove(StorageKeys.season, from: .caches)
                return
            }
        }
        for line in suburbanLines {
            if !StorageManager.shared.fileExists(StorageKeys.bus + line.id, in: .caches) {
                StorageManager.shared.remove(StorageKeys.season, from: .caches)
                return
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let window = self.window else { return }
        if let controller = window.visibleViewController() as? MainViewController {
            controller.setupCurrentDay()
            controller.refreshUI()
        }
    }
}

extension UIWindow {
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }

    static func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if let navigationController = vc as? UINavigationController,
            let visibleController = navigationController.visibleViewController  {
            return UIWindow.getVisibleViewControllerFrom( vc: visibleController )
        } else if let tabBarController = vc as? UITabBarController,
            let selectedTabController = tabBarController.selectedViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: selectedTabController )
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}
