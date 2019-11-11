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
    
    private static func add(type: String) -> String {
        return "rv=\(type)"
    }
    
    struct Line {
        private static let lineEndpoint = "all-lanes"
        
        //MARK: Product public endpoints
        public static func getFor(type: String) -> URL {
            return URL(string: baseUrl + lineEndpoint + "?" + add(type: type))!
        }
    }
    
    struct Bus {
        private static let busEndpoint = "all-buses"
        
        //MARK: Product public endpoints
        public static func getBy(id: String, day: String, type: String) -> URL {
            return URL(string: baseUrl + busEndpoint + "/" + id + "?" + add(type: type))!
        }
    }
}
