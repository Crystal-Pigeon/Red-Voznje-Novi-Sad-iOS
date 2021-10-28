//
//  UIColor+Extension.swift
//  BusNS
//
//  Created by Ena Vorkapic on 4/2/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import UIKit

extension UIColor {
    //Blue shades
    public static var blue: UIColor { return UIColor(named: "blue") ?? UIColor.systemBlue }
    public static var tansparentBlue: UIColor { return UIColor(named: "tansparentBlue") ?? UIColor.systemBlue }
    public static var darkBlue: UIColor { return UIColor(named: "darkBlue") ?? UIColor.systemBlue }
    public static var transparentDarkBlue: UIColor { return UIColor(named: "transparentDarkBlue") ?? UIColor.systemBlue }
    public static var transparentDarkBlueLighter: UIColor { return UIColor(named: "transparentDarkBlueLighter") ?? UIColor.systemBlue }
    
    //Orange shade
    public static var orange: UIColor { return UIColor(named: "orange") ?? UIColor.systemBlue }
    
    //GrayShades
    public static var lightGrey: UIColor { return UIColor(named: "lightGrey") ?? UIColor.systemBlue }
    public static var separatorGrey: UIColor { return UIColor(named: "separatorGrey") ?? UIColor.systemBlue }
    
    //White shades
    public static var white: UIColor { return UIColor(named: "white") ?? UIColor.systemBlue }
    public static var transparentWhite: UIColor { return UIColor(named: "transparentWhite") ?? UIColor.systemBlue }
    public static var transparentWhiteDarker: UIColor { return UIColor(named: "transparentWhiteDarker") ?? UIColor.systemBlue }
    public static var transparentWhiteLighter: UIColor { return UIColor(named: "transparentWhiteLighter") ?? UIColor.systemBlue }

    //Black shades
    public static var black: UIColor { return UIColor(named: "black") ?? UIColor.systemBlue }
    public static var heavyDark: UIColor { return UIColor(named: "heavyDark") ?? UIColor.systemBlue }
    public static var mediumDark: UIColor { return UIColor(named: "mediumDark") ?? UIColor.systemBlue }
    public static var lightDark: UIColor { return UIColor(named: "lightDark") ?? UIColor.systemBlue }
}

extension UIColor {
    public static var primary: UIColor { return UIColor(named: "primary")! }
    public static var secondary: UIColor { return UIColor(named: "secondary")! }
    public static var background: UIColor { return UIColor(named: "background")! }
    public static var primaryText: UIColor { return UIColor(named: "primaryText")! }
    public static var secondaryText: UIColor { return UIColor(named: "secondaryText")! }
    public static var cardBackground: UIColor { return UIColor(named: "cardBackground")! }
}
