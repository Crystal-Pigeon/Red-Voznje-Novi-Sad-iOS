//
//  ThemeMode.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

public enum ThemeMode: Int {
    case light
    case dark
    var description: String {
        switch self {
        case .dark:
            return "dark"
        default:
            return "light"
        }
    }
}

public enum ColorIdentifier: Int {
    case defaultColor
}

public enum FontIdentifier: Int {
    case defaultFont
}
