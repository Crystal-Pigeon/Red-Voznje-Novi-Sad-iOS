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
        .themeColor: .heavyDark,
        .backgroundColor: .mediumDark,
        .splashBackgroundColor: .blue,
        .shadowColor: .clear,
        .titleColor: .white,
        .busCell_currentHourColor: .orange,
        .busCell_lineTextColor: .transparentWhiteDarker,
        .dayIndicatorColor: .transparentWhiteDarker,
        .dayTextColor: .transparentWhiteDarker,
        .busCell_scheduleTextColor: .transparentWhiteDarker,
        .busCell_numberBackgroundColor: .blue,
        .busCell_numberTextColor: .white,
        .addButtonBackgroundColor: .blue,
        .navigationBackgroundColor: .heavyDark,
        .navigationTintColor: .white,
        .busCell_separatorColor: .transparentWhiteDarker,
        .busCell_backgroundColor: .lightDark,
        .busCell_extrasColor: .transparentWhiteDarker,
        .addLinesTable: .mediumDark,
        .addLinesLineColor: .transparentWhiteDarker,
        .mainScreenTextColor: .transparentWhiteDarker,
        .tableSeparatorColor: .transparentWhiteLighter,
        .supportBackgroundColor: .mediumDark,
        .supportTitleColor: .transparentWhiteDarker,
        .supportTextColor: .transparentWhiteDarker,
        .supportContactMailColor: .blue,
        .supportCopyrightsColor: .transparentWhiteDarker,
        .rearrangeFavoritesTable: .mediumDark,
        .rearrangeFavoritesLineColor: .transparentWhiteDarker,
        .settingsExplenationColor: .transparentWhiteDarker,
        .settingsMainColor: .transparentWhiteDarker,
        .settingsBackgroundColor: .lightDark,
        .settingsLineColor: .transparentWhiteDarker,
        .animationTextColor: .white
    ]
}
