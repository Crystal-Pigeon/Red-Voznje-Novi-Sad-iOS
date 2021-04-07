//
//  UIFont+Extension.swift
//  BusNS
//
//  Created by Ena Vorkapic on 4/2/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//


import UIKit

extension UIFont {
    //MARK: Regular
    public static var muliRegular10:            UIFont { return UIFont(name: "Muli-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10) }
    public static var muliRegular12:            UIFont { return UIFont(name: "Muli-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12) }
    public static var muliRegular13:            UIFont { return UIFont(name: "Muli-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13) }
    public static var muliRegular15:            UIFont { return UIFont(name: "Muli-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15) }
    public static var muliRegular17:            UIFont { return UIFont(name: "Muli-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17) }
    
    //MARK: Bold
    public static var muliSemiBold12:           UIFont { return UIFont(name: "Muli-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12) }
    public static var muliSemiBold13:           UIFont { return UIFont(name: "Muli-Bold", size: 13) ?? UIFont.systemFont(ofSize: 13) }
    public static var muliSemiBold20:           UIFont { return UIFont(name: "Muli-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20) }
    
    //MARK: Light
    public static var muliLight15:              UIFont { return UIFont(name: "Muli-Light", size: 15) ?? UIFont.systemFont(ofSize: 15) }
}
