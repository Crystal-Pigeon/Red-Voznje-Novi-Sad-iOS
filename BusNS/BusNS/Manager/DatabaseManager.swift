//
//  DatabaseManager.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation

public class DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    private init() {}
    
    var season: Season? {
        get {
            if StorageManager.fileExists(StorageKeys.season, in: .caches) {
                return StorageManager.retrieve(StorageKeys.season, from: .caches, as: Season.self)
            }
            return nil
        }
        set {
            StorageManager.store(newValue, to: .caches, as: StorageKeys.season)
        }
    }
    
    var urbanLines: [Line] {
        get {
            if StorageManager.fileExists(StorageKeys.urbanLines, in: .caches) {
                return StorageManager.retrieve(StorageKeys.urbanLines, from: .caches, as: [Line].self)
            }
            return []
        }
        set {
            StorageManager.store(newValue, to: .caches, as: StorageKeys.urbanLines)
        }
    }
    
    var suburbanLines: [Line] {
        get {
            if StorageManager.fileExists(StorageKeys.suburbanLines, in: .caches) {
                return StorageManager.retrieve(StorageKeys.suburbanLines, from: .caches, as: [Line].self)
            }
            return []
        }
        set {
            StorageManager.store(newValue, to: .caches, as: StorageKeys.suburbanLines)
        }
    }
    
    var favorites: [String] {
        get {
            if StorageManager.fileExists(StorageKeys.favorites, in: .caches) {
                return StorageManager.retrieve(StorageKeys.favorites, from: .caches, as: [String].self)
            }
            return []
        }
        set {
            StorageManager.store(newValue, to: .caches, as: StorageKeys.favorites)
        }
    }
    
    func getBusBy(id: String) -> [Bus] {
        let path = StorageKeys.bus + id
        if StorageManager.fileExists(path, in: .caches) {
            return StorageManager.retrieve(path, from: .caches, as: [Bus].self)
        }
        return []
    }
    
    func setBus(_ bus: [Bus]?, id: String) {
        let path = StorageKeys.bus + id
        StorageManager.store(bus, to: .caches, as: path)
    }
    
    var favoriteBuses: [[Bus]] {
        self.favorites.map({ busID in
            return self.getBusBy(id: busID)
        })
    }
    
    func removeFavorite(id: String) {
        favorites.removeAll(where: { busID in
            return busID == id
        })
    }
    
    func insertFavorite(id: String, at index: Int) {
        favorites.insert(id, at: index)
    }
    
    func appendFavorite(id: String) {
        favorites.append(id)
    }
}
