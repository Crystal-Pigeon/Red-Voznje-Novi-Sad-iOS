//
//  DarkTheme.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import UIKit

public class DarkTheme: Theme {
    
    override public var mode: ThemeMode {
        return .dark
    }
    
    public override func color(_ id: ColorIdentifier) -> UIColor {
        if let color = colorRepository[id] {
            return color
        }
        return super.color(id)
    }
    
    private lazy var colorRepository: [ColorIdentifier : UIColor] = [
        .themeColor: Colors.heavyDark,
        .backgroundColor: Colors.mediumDark,
        .splashBackgroundColor: Colors.blue,
        .shadowColor: Colors.clear,
        .titleColor: Colors.white,
        .busCell_currentHourColor: Colors.orange,
        .busCell_lineTextColor: Colors.transparentWhiteDarker,
        .dayIndicatorColor: Colors.transparentWhiteDarker,
        .dayTextColor: Colors.transparentWhiteDarker,
        .busCell_scheduleTextColor: Colors.transparentWhiteDarker,
        .busCell_numberBackgroundColor: Colors.blue,
        .busCell_numberTextColor: Colors.white,
        .addButtonBackgroundColor: Colors.blue,
        .navigationBackgroundColor: Colors.heavyDark,
        .navigationTintColor: Colors.white,
        .busCell_separatorColor: Colors.transparentWhiteDarker,
        .busCell_backgroundColor: Colors.lightDark,
        .busCell_extrasColor: Colors.transparentWhiteDarker,
        .addLinesTable: Colors.mediumDark,
        .addLinesLineColor: Colors.transparentWhiteDarker,
        .mainScreenTextColor: Colors.transparentWhiteDarker,
        .tableSeparatorColor: Colors.transparentWhiteLighter,
        .supportBackgroundColor: Colors.mediumDark,
        .supportTitleColor: Colors.transparentWhiteDarker,
        .supportTextColor: Colors.transparentWhiteDarker,
        .supportContactMailColor: Colors.blue,
        .supportCopyrightsColor: Colors.transparentWhiteDarker.withAlphaComponent(0.5),
        .rearrangeFavoritesTable: Colors.mediumDark,
        .rearrangeFavoritesLineColor: Colors.transparentWhiteDarker,
        .settingsExplenationColor: Colors.transparentWhiteDarker.withAlphaComponent(0.5),
        .settingsMainColor: Colors.transparentWhiteDarker,
        .settingsBackgroundColor: Colors.lightDark,
        .settingsLineColor: Colors.transparentWhiteDarker.withAlphaComponent(0.25),
    ]
}
