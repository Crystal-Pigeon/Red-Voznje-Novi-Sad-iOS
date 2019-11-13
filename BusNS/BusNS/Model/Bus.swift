//
//  Bus.swift
//  BusNS
//
//  Created by Mariana Samardzic on 13/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

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
