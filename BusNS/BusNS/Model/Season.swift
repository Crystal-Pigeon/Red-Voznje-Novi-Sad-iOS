//
//  Season.swift
//  BusNS
//
//  Created by Mariana Samardzic on 13/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

struct Season: Codable {
    let date: String
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case date = "datum"
        case season = "redv"
    }
}

extension Season: Equatable {
    public static func ==(lhs: Season, rhs: Season) -> Bool {
        if lhs.date != rhs.date { return false }
        return lhs.season == rhs.season
    }
}
