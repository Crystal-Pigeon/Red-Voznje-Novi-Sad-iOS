//
//  Service.swift
//  BusNS
//
//  Created by Marko Popić on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
import Alamofire

class Service {
    
    // MARK: - Properties
    let networkManager: NetworkManagerProtocol
    let network: NetworkProtocol
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json"]
    
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared, network: NetworkProtocol = Network.shared){
        self.networkManager = networkManager
        self.network = network
    }
}
