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
    case themeColor, splashBackgroundColor, backgroundColor, shadowColor, titleColor, navigationBackgroundColor, navigationTintColor, mainScreenTextColor
    case dayIndicatorColor, dayTextColor
    case addButtonBackgroundColor, addButtonTextColor
    case busCell_backgroundColor, busCell_currentHourColor, busCell_extrasColor, busCell_scheduleTextColor, busCell_numberBackgroundColor, busCell_numberTextColor, busCell_lineTextColor, busCell_separatorColor
    case addLinesTable, tableSeparatorColor
    case supportBackgroundColor, supportTitleColor, supportTextColor, supportContactMailColor, supportCopyrightsColor
}
