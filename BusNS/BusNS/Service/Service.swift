//
//  Service.swift
//  BusNS
//
//  Created by Marko Popić on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
import Alamofire

public protocol Service {
    var headers: HTTPHeaders { get }
}

extension Service {
    var headers: HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
