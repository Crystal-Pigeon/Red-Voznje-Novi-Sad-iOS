//
//  Network.swift
//  BusNS
//
//  Created by Mariana Samardzic on 18.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkProtocol {
    func sendRequest(headers: HTTPHeaders, endpoint: URL, completionHandler: @escaping (Bool, Int?, Data?) -> Void )
}

class Network: NetworkProtocol {
    
    private init(){}
    
    public static let shared = Network()
    
    func sendRequest(headers: HTTPHeaders, endpoint: URL, completionHandler: @escaping (Bool, Int?, Data?) -> Void ) {
        AF.request(endpoint, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            
            var failed = false
            switch response.result {
            case .failure:
                failed = true
            default: break
            }
            
            let statusCode = response.response?.statusCode
            let data = response.data
            completionHandler(failed, statusCode, data)
        }
    }
}
