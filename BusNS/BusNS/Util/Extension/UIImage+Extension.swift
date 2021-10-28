//
//  UIImage+Extension.swift
//  BusNS
//
//  Created by Ena Vorkapic on 4/2/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import UIKit

extension UIImage {
    public static var logo:                                 UIImage { return UIImage(named: "logo")! }
    public static var gearshape: UIImage { if #available(iOS 13.0, *) {
        return UIImage(systemName: "gearshape.fill")!
    } else {
        return UIImage(named: "settings_icon")!
    }}
    
    public static var arrange: UIImage { if #available(iOS 13.0, *) {
        return UIImage(systemName: "arrow.up.and.down.and.arrow.left.and.right")!
    } else {
        return UIImage(named: "rearrange_icon")!
    }}
    
    public static var plus: UIImage { if #available(iOS 13.0, *) {
        return UIImage(systemName: "plus")!.withTintColor(.white)
    } else {
        return UIImage(named: "plus-white")!
    }}
}
