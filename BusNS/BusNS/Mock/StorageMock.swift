//
//  StorageMock.swift
//  BusNS
//
//  Created by Mariana Samardzic on 19.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation

class StorageMock: StorageService {
    
    let data: Dictionary<String, Any>?
    
    init(data: Dictionary<String, Any>? = nil) {
        self.data = data
    }
    
    func store<T>(_ object: T, to directory: Directory, as fileName: String) where T : Encodable {
        
    }
    
    func retrieve<T>(_ fileName: String, from directory: Directory, as type: T.Type) -> T where T : Decodable {
        guard let data = self.data else {
            fatalError()
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let model = try! decoder.decode(type, from: jsonData)
        return model
    }
    
    func clear(_ directory: Directory) {
        
    }
    
    func remove(_ fileName: String, from directory: Directory) {
        
    }
    
    func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        if data != nil {
            return true
        } else {
            return false
        }
    }
    
}
