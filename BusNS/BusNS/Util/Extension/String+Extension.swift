//
//  String+Extension.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
    }
}

extension Date {
    static var currentHour: String {
        return "\(Calendar.current.component(.hour, from: Date()))"
    }
    
    static var currentWeekday: Int {
        let weekday = Calendar.current.component(.weekday, from: Date())
        if weekday == 1 {
            return 2
        } else if weekday == 7 {
            return 1
        }
        return 0
    }
}
