//
//  Theme.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import UIKit

public class Theme {
    //MARK: Current theme
    public static var current: Theme = LightTheme()
    
    //MARK: Theme mode
    public var mode: ThemeMode {
        return .light
    }
    
    //MARK: Getting color for color identifier
    public func color(_ id: ColorIdentifier) -> UIColor {
        if let color = colorRepository[id] {
            return color
        }
        return colorRepository[.defaultColor]!
    }
    
    //MARK: Setting colors for color identifiers
    private lazy var colorRepository: [ColorIdentifier : UIColor] = [
        .defaultColor : .black
    ]
}
