//
//  Line.swift
//  BusNS
//
//  Created by Marko Popić on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

struct Line: Codable {
    let id: String
    let number: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case number = "broj"
        case name = "linija"
    }
}

extension Line: Equatable {
    public static func == (lhs: Line, rhs: Line) -> Bool {
        if lhs.id != rhs.id { return false }
        if lhs.number != rhs.number { return false }
        return lhs.name == rhs.name
    }
}
