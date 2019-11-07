//
//  LightTheme.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import UIKit

public class LightTheme: Theme {
    
    override public var mode: ThemeMode {
        return .light
    }
    
    public override func font(_ id: FontIdentifier) -> UIFont {
        if let font = fontRepository[id] {
            return font
        }
        return super.font(id)
    }
    
    public override func color(_ id: ColorIdentifier) -> UIColor {
        if let color = colorRepository[id] {
            return color
        }
        return super.color(id)
    }
    
    private lazy var colorRepository: [ColorIdentifier : UIColor] = [:]
    
    private lazy var fontRepository: [FontIdentifier : UIFont] = [:]
}
