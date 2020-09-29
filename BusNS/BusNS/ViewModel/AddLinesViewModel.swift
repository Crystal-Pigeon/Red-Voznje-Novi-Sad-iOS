//
//  AddLinesViewModel.swift
//  BusNS
//
//  Created by Marko Popić on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
import Firebase

protocol AddLinesObserver {
    func refreshUI()
    func showLoader()
    func fetchedAll()
    func didNotFetchAll()
}

class AddLinesViewModel {
    public var observer: AddLinesObserver?
    public private(set) var urbanLines = [Line]()
    public private(set) var suburbanLines = [Line]()
    public private(set) var favorites: [String] {
        get {
            return BusManager.favorites
        }
        set {
            BusManager.favorites = newValue
        }
    }
    
    init() {
        BusManager.linesViewModel = self
    }
    
    public func addToFavourites(id: String){
        if favorites.contains(id) {
            favorites.removeAll { (element) -> Bool in
                return id == element
            }
        } else {
            favorites.append(id)
            Analytics.logEvent("bus_favourite" , parameters: ["line":id])
        }
        BusManager.storeFavorites()
    }
    
    public func getLines() {
        guard let delegate = self.observer else { return }
        if StorageManager.fileExists(StorageKeys.urbanLines, in: .caches) && StorageManager.fileExists(StorageKeys.suburbanLines, in: .caches) {
            self.urbanLines = StorageManager.retrieve(StorageKeys.urbanLines, from: .caches, as: [Line].self)
            self.suburbanLines = StorageManager.retrieve(StorageKeys.suburbanLines, from: .caches, as: [Line].self)
            delegate.refreshUI()
        } else {
            delegate.showLoader()
        }
    }
    
    public func fetchedAll() {
        guard StorageManager.fileExists(StorageKeys.urbanLines, in: .caches) && StorageManager.fileExists(StorageKeys.suburbanLines, in: .caches) else { return }
        self.urbanLines = StorageManager.retrieve(StorageKeys.urbanLines, from: .caches, as: [Line].self)
        self.suburbanLines = StorageManager.retrieve(StorageKeys.suburbanLines, from: .caches, as: [Line].self)
        guard let delegate = self.observer else { return }
        delegate.fetchedAll()
    }
    
    public func didNotFetchAll() {
        guard let delegate = self.observer else { return }
        delegate.didNotFetchAll()
    }
    
    public func refreshLines() {
        self.getLines()
        guard let delegate = self.observer else { return }
        delegate.refreshUI()
    }
}
