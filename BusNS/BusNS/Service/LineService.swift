//
//  LineService.swift
//  BusNS
//
//  Created by Marko Popić on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Property declarations
class LineService: Service {
    
    public func getSuburbanLines(completionHandler: @escaping (_ data: [Line]?, _ error: ServiceError?) -> Void) {
        getLines(type: "rvp") { (line, error) in
            completionHandler(line,error)
        }
    }
    
    public func getUrbanLines(completionHandler: @escaping (_ data: [Line]?, _ error: ServiceError?) -> Void) {
        getLines(type: "rvg") { (line, error) in
            completionHandler(line,error)
        }
    }
    
    public func getLines(type: String, completionHandler: @escaping (_ data: [Line]?, _ error: ServiceError?) -> Void) {
        if !self.networkManager.isInternetAvailable() {
            completionHandler(nil,ServiceError.internetError)
            return
        }
        
        network.sendRequest(headers: self.headers, endpoint: Endpoint.Line.getFor(type: type)) { (failed, statusCode, data) in
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
                    let data = try decoder.decode([Line].self, from: data)
                    completionHandler(data,nil)
                } catch {
                    let error = ServiceError(message: "Problem with server".localized())
                    completionHandler(nil,error)
                }
            default:
                do {
                    let serviceError = try decoder.decode(ServiceError.self, from: data)
                    completionHandler(nil,serviceError)
                } catch {
                    let error = ServiceError(message: "Problem with server".localized())
                    completionHandler(nil,error)
                }
            }
        }
    }
}
