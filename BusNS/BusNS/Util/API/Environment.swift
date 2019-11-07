//
//  Environment.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

enum Environment {
    
    case development
    case production
    
    public var baseURL: String {
        return "\(urlProtocol)\(stagging)\(domain)\(route)"
    }
    
    private var urlProtocol: String {
        switch self {
        case .production:
            return "https://"
        default:
            return "https://"
        }
    }
    
    private var stagging: String {
        switch self {
        case .production:
            return "busnsapi.herokuapp"
        default:
            return "busnsapi.herokuapp"
        }
    }
    
    private var domain: String {
        switch self {
        case .production:
            return ".com"
        default:
            return ".com"
        }
    }
    
    private var route: String {
        switch self {
        case .production:
            return "/"
        default:
            return "/"
        }
    }
}
