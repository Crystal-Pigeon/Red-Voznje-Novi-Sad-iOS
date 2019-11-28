//
//  Bundle+Extension.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

extension Bundle {
    public static func localizedBundle() -> Bundle! {
        var appLang = "en"
        if StorageManager.fileExists(StorageKeys.language, in: .caches) {
            appLang = StorageManager.retrieve(StorageKeys.language, from: .caches, as: String.self)
        }
        
        let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
        return Bundle(path: path!)
    }
}
