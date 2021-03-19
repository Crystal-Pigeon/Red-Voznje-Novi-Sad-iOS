//
//  NetworkMock.swift
//  BusNS
//
//  Created by Mariana Samardzic on 19.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation
import Alamofire

class NetworkMock: NetworkProtocol {
    
    enum NetworkType {
        case failed
        case statusCodeFailed
        case statusCodeMessage
        case statusCodeMessageBadFormat
        case noData
        case dataBadFormat
        case correct
    }
    
    let networkType: NetworkType
    let errorMessage: Dictionary<String, Any>?
    let data: [Dictionary<String, Any>]?
    
    init(networkType: NetworkType, errorMessage: Dictionary<String, Any>? = nil, data: [Dictionary<String, Any>]? = nil) {
        self.networkType = networkType
        self.errorMessage = errorMessage
        self.data = data
    }
    
    func sendRequest(headers: HTTPHeaders, endpoint: URL, completionHandler: @escaping (Bool, Int?, Data?) -> Void) {
        switch networkType {
        case .failed:
            completionHandler(true, nil, nil)
            
        case .statusCodeFailed:
            completionHandler(false,500, nil )
            
        case .statusCodeMessage:
            let jsonData = try? JSONSerialization.data(withJSONObject: errorMessage!, options: .prettyPrinted)
            completionHandler(false, 500, jsonData)
            
        case .statusCodeMessageBadFormat:
            let jsonData = try? JSONSerialization.data(withJSONObject: errorMessage!, options: .prettyPrinted)
            completionHandler(false, 500, jsonData)
            
        case .noData:
            completionHandler(false, 200, nil)
            
        case .dataBadFormat:
            let jsonData = try? JSONSerialization.data(withJSONObject: self.data!, options: .prettyPrinted)
        completionHandler(false, 200, jsonData)
            
        case .correct:
            let jsonData = try? JSONSerialization.data(withJSONObject: self.data!, options: .prettyPrinted)
        completionHandler(false, 200, jsonData)
        }
    }
}
