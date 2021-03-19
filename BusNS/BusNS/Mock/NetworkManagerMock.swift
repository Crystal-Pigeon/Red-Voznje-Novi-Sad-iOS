//
//  NetworkManagerMock.swift
//  BusNS
//
//  Created by Mariana Samardzic on 19.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation

class NetworkManagerMock: NetworkManagerProtocol {
    
    enum NetworkManagerType {
        case offline
        case online
    }
    
    let networkManagerType: NetworkManagerType
    
    init(networkManagerType: NetworkManagerType) {
        self.networkManagerType = networkManagerType
    }
    
    func isInternetAvailable() -> Bool {
        switch networkManagerType {
        case .offline:
            return false
        case .online:
            return true
        }
    }
}
