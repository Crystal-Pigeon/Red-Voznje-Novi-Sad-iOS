//
//  SeasonService.swift
//  BusNS
//
//  Created by Mariana Samardzic on 13/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
import Alamofire

class SeasonService: Service {
    
    // MARK: - Methods
    public func getSeason(completionHandler: @escaping (_ data: [Season]?, _ error: ServiceError?) -> Void) {
        if !networkManager.isInternetAvailable() {
            completionHandler(nil, ServiceError.internetError)
            return
        }
        
        self.network.sendRequest(headers: self.headers, endpoint: Endpoint.Season.get()) { (failed, statusCode, data) in
            
            if failed {
                completionHandler(nil, ServiceError.internetError)
                return
            }
            
            guard let statusCode = statusCode else { return }
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            switch(statusCode) {
            case 200..<300:
                do {
                    let data = try decoder.decode([Season].self, from: data)
                    completionHandler(data,nil)
                } catch {
                    let error = ServiceError(message: "Problem with server".localized())
                    completionHandler(nil, error)
                }
            default:
                do {
                    let serviceError = try decoder.decode(ServiceError.self, from: data)
                    completionHandler(nil, serviceError)
                } catch {
                    let error = ServiceError(message: "Problem with server".localized())
                    completionHandler(nil, error)
                }
            }
        }
    }
}

