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
        .themeColor: .blue,
        .backgroundColor: .lightGrey,
        .splashBackgroundColor: .blue,
        .shadowColor: .transparentDarkBlue,
        .titleColor: .white,
        .busCell_currentHourColor: .orange,
        .busCell_lineTextColor: .darkBlue,
        .dayIndicatorColor: .transparentWhite,
        .dayTextColor: .white,
        .busCell_scheduleTextColor: .darkBlue,
        .busCell_numberBackgroundColor: .blue,
        .busCell_numberTextColor: .white,
        .addButtonBackgroundColor: .white,
        .navigationBackgroundColor: .blue,
        .navigationTintColor: .white,
        .busCell_separatorColor: .transparentDarkBlueLighter,
        .busCell_backgroundColor: .white,
        .busCell_extrasColor: .transparentDarkBlue,
        .addLinesTable: .white,
        .addLinesLineColor: .darkBlue,
        .mainScreenTextColor: .transparentDarkBlue,
        .supportBackgroundColor: .lightGrey,
        .supportTitleColor: .darkBlue,
        .supportTextColor: .darkBlue,
        .supportContactMailColor: .blue,
        .supportCopyrightsColor: .transparentDarkBlue,
        .settingsBackgroundColor: .white,
        .settingsMainColor: .darkBlue,
        .settingsExplenationColor: .transparentDarkBlue,
        .settingsLineColor: .transparentDarkBlueLighter,
        .rearrangeFavoritesTable: .white,
        .rearrangeFavoritesLineColor: .darkBlue,
        .tableSeparatorColor: .separatorGrey,
        .animationTextColor: .white
    ]
}
