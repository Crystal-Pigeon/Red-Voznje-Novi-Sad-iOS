//
//  Bus.swift
//  BusNS
//
//  Created by Mariana Samardzic on 13/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

struct Bus: Codable {
    let id: String
    let number: String
    let name: String
    let lineA: String?
    let lineB: String?
    let line: String?
    let day: String
    let scheduleA: [String: [String]]?
    let scheduleB: [String: [String]]?
    let schedule: [String: [String]]?
    let extras: String
    
    var fullName: String {
        number + " " + name
    }
    
    var isOneWay: Bool {
        return lineA == nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case number = "broj"
        case name = "naziv"
        case lineA = "linijaA"
        case lineB = "linijaB"
        case line = "linija"
        case day = "dan"
        case scheduleA = "rasporedA"
        case scheduleB = "rasporedB"
        case schedule = "raspored"
        case extras = "dodaci"
    }
    
    private func getScheduleBy3Hours(schedule: [String:[String]]) -> [String] {
        let allHours = self.getScheduleByHour(schedule: schedule)
        var threeHours = [String]()
        let hour = Date.currentHourNumber
        for oneHour in allHours {
            guard let hourInt = Int(oneHour.split(separator: ":")[0]) else { break }
            if (hourInt == hour - 1 || hourInt >= hour) {
                if threeHours.count < 3 {
                    threeHours.append(oneHour)
                    continue
                }
                break
            }
        }
        if threeHours.count < 3 {
            for oneHour in allHours {
                if threeHours.count < 3 {
                    threeHours.append(oneHour)
                    continue
                }
                break
            }
        }
        return threeHours
    }
    
    private func getScheduleByHour(schedule: [String:[String]]) -> [String] {
        var hours = [String]()
        for hour in schedule {
            var wholeHour = hour.key + ": "
            for min in hour.value {
                wholeHour += min + " "
            }
            hours.append(wholeHour)
        }
        hours.sort { (first, second) -> Bool in
            return first < second
        }
        return hours
    }
    
    public func getScheduleABy3Hours() -> [String] {
        guard let scheduleA = self.scheduleA else { return []}
        return getScheduleBy3Hours(schedule: scheduleA)
    }
    
    public func getScheduleBBy3Hours() -> [String] {
        guard let scheduleB = self.scheduleB else { return []}
        return getScheduleBy3Hours(schedule: scheduleB)
    }
    
    public func getOneWayScheduleBy3Hours() -> [String] {
        guard let schedule = self.schedule else { return []}
        return getScheduleBy3Hours(schedule: schedule)
    }
    
    public func getScheduleAByHour() -> [String] {
        guard let scheduleA = self.scheduleA else { return []}
        return getScheduleByHour(schedule: scheduleA)
    }
    
    public func getScheduleBByHour() -> [String] {
        guard let scheduleB = self.scheduleB else { return []}
        return getScheduleByHour(schedule: scheduleB)
    }
    
    public func getOneWayScheduleByHour() -> [String] {
        guard let schedule = self.schedule else { return []}
        return getScheduleByHour(schedule: schedule)
    }
    
    public func formatedExtras() -> String {
        var returnValue = ""
        let array = self.extras.split(separator: ",")
        for element in array {
            if !element.contains("-") {
                let extra = element.split(separator: "=")
                var extraString = ""
                for var word in extra {
                    if word.first == " " { word.removeFirst() }
                    if extra.last == word {
                        extraString += "\(word) "
                    } else {
                        extraString += "\(word) = "
                    }
                }
                returnValue += "\(extraString)\n"
            }
        }
        if returnValue.last == "\n" { returnValue.removeLast() }
        return returnValue
    }
}

extension Bus: Equatable {
    public static func ==(lhs: Bus, rhs: Bus) -> Bool{
        if lhs.id != rhs.id { return false }
        if lhs.number != rhs.number { return false }
        if lhs.name != rhs.name { return false }
        if lhs.lineA != rhs.lineA { return false }
        if lhs.lineB != rhs.lineB { return false }
        if lhs.line != rhs.line {return false}
        if lhs.day != rhs.day { return false }
        if lhs.scheduleA != rhs.scheduleA { return false }
        if lhs.scheduleB != rhs.scheduleB { return false }
        if lhs.schedule != rhs.schedule { return false }
        return lhs.extras == rhs.extras
    }
}
