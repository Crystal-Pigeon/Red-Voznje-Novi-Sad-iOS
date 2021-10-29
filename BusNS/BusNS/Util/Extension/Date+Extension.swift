//
//  Date+Extension.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation

extension Date {
    static var currentHour: String {
        let currentHour = currentHourNumber
        if currentHour < 10 {
            return "0\(currentHour)"
        }
        return "\(currentHour)"
    }
    
    static var currentHourNumber: Int {
        return Calendar.current.component(.hour, from: Date())
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
