//
//  Endpoint.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

struct Endpoint {
    private static let environment: Environment = .development
    private static let baseUrl = environment.baseURL
    
    private static func add(day: String) -> String {
        return "dan=\(day)"
    }
    
    private static func add(type: String) -> String {
        return "rv=\(type)"
    }
    
    struct Line {
        private static let lineEndpoint = "lanes"
        
        //MARK: Product public endpoints
        public static func getFor(day: String, type: String) -> URL {
            return URL(string: baseUrl + lineEndpoint + "?" + add(day: day) + "&" + add(type: type))!
        }
    }
    
    struct Bus {
        private static let busEndpoint = "buses"
        
        //MARK: Product public endpoints
        public static func getBy(id: String, day: String, type: String) -> URL {
            return URL(string: baseUrl + busEndpoint + "/" + id + "?" + add(day: day) + "&" + add(type: type))!
        }
    }
}
