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
    
    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Init
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared){
        self.networkManager = networkManager
    }
    
    // MARK: - Instances
    public static var shared = SeasonService()
    public static var testOffline = SeasonService(networkManager: NetworkManagerOfflineMock())
    public static var testOnline = SeasonService(networkManager: NetworkManagerOfflineMock())
    
    // MARK: - Methods
    public func getSeason(completionHandler: @escaping (_ data: [Season]?, _ error: ServiceError?) -> Void) {
        if !networkManager.isInternetAvailable() {
            completionHandler(nil, ServiceError.internetError)
            return
        }
        
        AF.request(Endpoint.Season.get(), method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
                case .failure:
                    completionHandler(nil, ServiceError.internetError)
                    return
                default: break
            }
            guard let statusCode = response.response?.statusCode else { return }
            guard let data = response.data else { return }
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
