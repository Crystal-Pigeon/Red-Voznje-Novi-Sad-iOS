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
    
    private init(){}
    
    public static var shared = BusService()
    
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
    
    private func getBus(type: String, id: String , completionHandler: @escaping (_ data: [Bus]?, _ error: ServiceError?) -> Void) {
        if !NetworkManager.shared.isInternetAvailable() {
            completionHandler(nil, ServiceError.internetError)
            return
        }
        AF.request(Endpoint.Bus.getBy(id: id, type: type), method: .get, encoding: JSONEncoding.default, headers:  headers).responseJSON { response in
            guard let statusCode = response.response?.statusCode else { return }
            guard let data = response.data else { return }
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
