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
        
        FirebaseApp.configure()
        
        DownloadManager.shared.checkSeason()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = ASNavigationController(rootViewController: HomeViewController())
        window.rootViewController = navigationController
        window.rootViewController?.setupNavigationBarAppearance()
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }
}
