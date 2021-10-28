//
//  HomeViewModel.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation

class HomeViewModel: NSObject {
    
    var workdayBuses: [Bus] {
        let allBuses = DatabaseManager.shared.favoriteBuses
        var result = [Bus]()
        for buses in allBuses {
            result += buses.filter({ bus in
                return bus.day == "R"
            })
        }
        return result
    }
    
    var saturdayBuses: [Bus] {
        let allBuses = DatabaseManager.shared.favoriteBuses
        var result = [Bus]()
        for buses in allBuses {
            result += buses.filter({ bus in
                return bus.day == "S"
            })
        }
        return result
    }
    
    var sundayBuses: [Bus] {
        let allBuses = DatabaseManager.shared.favoriteBuses
        var result = [Bus]()
        for buses in allBuses {
            result += buses.filter({ bus in
                return bus.day == "N"
            })
        }
        return result
    }
}
