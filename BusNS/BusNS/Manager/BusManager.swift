//
//  BusManager.swift
//  BusNS
//
//  Created by Marko Popić on 11/22/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

class BusManager {
    
    public static var favorites = [String]()
    private static let path = StorageKeys.favorites
    
    public static func storeFavorites() {
        StorageManager.store(self.favorites, to: .caches, as: path)
    }
    
    public static func retriveFavorites() {
        if StorageManager.fileExists(path, in: .caches) {
            self.favorites = StorageManager.retrieve(path, from: .caches, as: [String].self)
        }
    }
}
