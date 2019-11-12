//
//  Environment.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

enum Environment {
    
    case gspns
    case heroku
    
    public var baseURL: String {
        return "\(urlProtocol)\(stagging)\(domain)\(route)"
    }
    
    private var urlProtocol: String {
        switch self {
        case .heroku:
            return "https://"
        case .gspns:
            return "http://"
        }
    }
    
    private var stagging: String {
        switch self {
        case .heroku:
            return "busnsapi.herokuapp"
        case .gspns:
            return "www.gspns"
        }
    }
    
    private var domain: String {
        switch self {
        case .heroku:
            return ".com"
        case .gspns:
            return ".rs"
        }
    }
    
    private var route: String {
        switch self {
        case .heroku:
            return "/"
        case .gspns:
            return "/feeds/"
        }
    }
}
