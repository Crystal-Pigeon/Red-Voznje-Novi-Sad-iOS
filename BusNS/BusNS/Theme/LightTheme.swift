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
    
    public override func color(_ id: ColorIdentifier) -> UIColor {
        if let color = colorRepository[id] {
            return color
        }
        return super.color(id)
    }
    
    private lazy var colorRepository: [ColorIdentifier : UIColor] = [
        .themeColor: Colors.blue,
        .backgroundColor: Colors.lightGrey,
        .splashBackgroundColor: Colors.blue,
        .shadowColor: Colors.transparentDarkBlue,
        .titleColor: Colors.white,
        .busCell_currentHourColor: Colors.orange,
        .busCell_lineTextColor: Colors.darkBlue,
        .dayIndicatorColor: Colors.transparentWhite,
        .dayTextColor: Colors.white,
        .busCell_scheduleTextColor: Colors.darkBlue,
        .busCell_numberBackgroundColor: Colors.blue,
        .busCell_numberTextColor: Colors.white,
        .addButtonBackgroundColor: Colors.white,
        .navigationBackgroundColor: Colors.blue,
        .navigationTintColor: Colors.white,
        .busCell_separatorColor: Colors.transparentDarkBlueLighter,
        .busCell_backgroundColor: Colors.white,
        .busCell_extrasColor: Colors.transparentDarkBlue,
        .addLinesTable: Colors.white,
        .addLinesLineColor: Colors.darkBlue,
        .mainScreenTextColor: Colors.transparentDarkBlue,
        .supportBackgroundColor: Colors.lightGrey,
        .supportTitleColor: Colors.darkBlue,
        .supportTextColor: Colors.darkBlue,
        .supportContactMailColor: Colors.blue,
        .supportCopyrightsColor: Colors.transparentDarkBlue,
        .settingsBackgroundColor: Colors.white,
        .settingsMainColor: Colors.darkBlue,
        .settingsExplenationColor: Colors.transparentDarkBlue,
        .settingsLineColor: Colors.transparentDarkBlueLighter,
        .rearrangeFavoritesTable: Colors.white,
        .rearrangeFavoritesLineColor: Colors.darkBlue
    ]
}
