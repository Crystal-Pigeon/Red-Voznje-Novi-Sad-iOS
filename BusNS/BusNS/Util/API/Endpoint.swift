//
//  Endpoint.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

struct Endpoint {
    private static let environmentHeroku: Environment = .heroku
    private static let environmentGspns: Environment = .gspns
    private static let herokuBaseUrl = environmentHeroku.baseURL
    private static let gspnsBaseUrl = environmentGspns.baseURL
    
    private static func add(type: String) -> String {
        return "rv=\(type)"
    }
    
    struct Line {
        private static let lineEndpoint = "all-lanes"
        
        //MARK: Product public endpoints
        public static func getFor(type: String) -> URL {
            return URL(string: herokuBaseUrl + lineEndpoint + "?" + add(type: type))!
        }
    }
    
    struct Bus {
        private static let busEndpoint = "all-buses"
        
        //MARK: Product public endpoints
        public static func getBy(id: String, day: String, type: String) -> URL {
            return URL(string: herokuBaseUrl + busEndpoint + "/" + id + "?" + add(type: type))!
        }
    }
    
    struct Season {
        private static let seasonEndpoint = "red-voznje"
        
        //MARK: Product public endpoints
        public static func get() -> URL {
            return URL(string: gspnsBaseUrl + seasonEndpoint)!
        }
    }
}
