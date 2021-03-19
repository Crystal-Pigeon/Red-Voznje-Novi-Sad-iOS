//
//  File.swift
//  BusNS
//
//  Created by Mariana Samardzic on 14/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
import Alamofire

class BusService: Service {

    public func getSuburbanBus(id: String, completionHandler: @escaping (_ data: [Bus]?, _ error: ServiceError?) -> Void) {
        getBus(type: "rvp", id: id) { (buses, error) in
            completionHandler(buses, error)
        }
    }
    
    public func getUrbanBus(id: String, completionHandler: @escaping (_ data: [Bus]?, _ error: ServiceError?) -> Void) {
        getBus(type: "rvg", id: id) { (buses, error) in
            completionHandler(buses, error)
        }
    }
    
    public func getBus(type: String, id: String , completionHandler: @escaping (_ data: [Bus]?, _ error: ServiceError?) -> Void) {
        if !self.networkManager.isInternetAvailable() {
            completionHandler(nil, ServiceError.internetError)
            return
        }
        
        self.network.sendRequest(headers: self.headers, endpoint: Endpoint.Bus.getBy(id: id, type: type)) { (failed, statusCode, data) in
            
            if failed {
                completionHandler(nil, ServiceError.internetError)
                return
            }

            guard let statusCode = statusCode else { return }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            switch statusCode {
            case 200..<300:
                do {
                    let data = try decoder.decode([Bus].self, from: data)
                    completionHandler(data, nil)
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
