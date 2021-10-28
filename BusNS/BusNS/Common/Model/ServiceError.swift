//
//  ServiceError.swift
//  BusNS
//
//  Created by Marko Popić on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

struct ServiceError: Codable {
    let message: String
    
    public static var internetError: ServiceError {
        return ServiceError(message: "No internet connection".localized())
    }
}

extension ServiceError: Equatable {
    public static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        return lhs.message == rhs.message
    }
}
