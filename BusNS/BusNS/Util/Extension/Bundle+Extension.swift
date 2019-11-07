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
        let appLang = Locale.current.languageCode
        let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
        return Bundle(path: path!)
    }
}
