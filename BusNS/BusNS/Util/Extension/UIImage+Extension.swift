//
//  UIImage+Extension.swift
//  BusNS
//
//  Created by Ena Vorkapic on 4/2/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import UIKit

extension UIImage {
    //Logos
    public static var logo:                                 UIImage { return UIImage(named: "logo")! }
    public static var logoWhite:                            UIImage { return UIImage(named: "logo-white")! }
    
    //Home
    public static var plus:                                 UIImage { return UIImage(named: "plus")! }
    public static var plusWhite:                            UIImage { return UIImage(named: "plus-white")! }
    public static var rearrange:                            UIImage { return UIImage(named: "rearrange_icon")! }
    public static var settings:                             UIImage { return UIImage(named: "settings_icon")! }
    
    //Add lines
    public static var rightArrowLight:                      UIImage { return UIImage(named: "right_arrow_light")! }
    public static var rightArrowDark:                       UIImage { return UIImage(named: "right_arrow_dark")! }
    
    //Settings
    public static var email:                                UIImage { return UIImage(named: "email_icon")! }
}
