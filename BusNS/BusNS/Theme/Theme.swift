//
//  Theme.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import UIKit

public class Theme {
    
    //MARK: Color objects
    public let blackColor = UIColor.black
    
    //MARK: Font objects
    public let defaultFont = UIFont.systemFont(ofSize: 12)
    
    //MARK: Current theme
    public static var current: Theme = LightTheme()
    
    //MARK: Theme mode
    public var mode: ThemeMode {
        return .light
    }
    
    public func font(_ id: FontIdentifier) -> UIFont {
        if let font = fontRepository[id] {
            return font
        }
        return fontRepository[.defaultFont]!
    }
    
    public func color(_ id: ColorIdentifier) -> UIColor {
        if let color = colorRepository[id] {
            return color
        }
        return colorRepository[.defaultColor]!
    }
    
    private lazy var colorRepository: [ColorIdentifier : UIColor] = [
        .defaultColor : blackColor
    ]
    
    private lazy var fontRepository: [FontIdentifier : UIFont] = [
        .defaultFont : defaultFont
    ]
}
