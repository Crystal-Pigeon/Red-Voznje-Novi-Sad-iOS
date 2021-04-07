//
//  DateManager.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/13/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

public struct DateManager {
    
    public static let instance = DateManager()
    
    private init() {}
    
    public func getDayOfWeek() -> String {
        let weekday = Calendar.current.component(.weekday, from: Date())
        if weekday == 1 {
            return "N"
        } else if weekday == 7 {
            return "S"
        }
        return "R"
    }
    
    public func getHour() -> Int {
        return Calendar.current.component(.hour, from: Date())
    }
}
