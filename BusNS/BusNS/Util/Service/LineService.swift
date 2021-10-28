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
    
    private init(){}
    
    public static var shared = LineService()
    
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
    
    private func getLines(type: String, completionHandler: @escaping (_ data: [Line]?, _ error: ServiceError?) -> Void) {
        if !NetworkManager.shared.isInternetAvailable() {
            completionHandler(nil,ServiceError.internetError)
            return
        }
        
        AF.request(Endpoint.Line.getFor(type: type), method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
                case .failure:
                    completionHandler(nil, ServiceError.internetError)
                    return
                default: break
            }
            guard let statusCode = response.response?.statusCode else { return }
            guard let data = response.data else { return }
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
