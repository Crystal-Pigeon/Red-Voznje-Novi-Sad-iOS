//
//  AddLinesViewModel.swift
//  BusNS
//
//  Created by Marko Popić on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

protocol AddLinesObserver {
    func refreshUI()
    func showLoader()
}

class AddLinesViewModel {
    public var observer: AddLinesObserver?
    public private(set) var urbanLines = [Line]()
    public private(set) var suburbanLines = [Line]()
    public private(set) var favourites = [String]()
    
    init() {}
    
    public func addToFavourites(id: String){
        if let index = favourites.firstIndex(of: id) {
            favourites.remove(at: index)
        } else {
            favourites.append(id)
        }
        StorageManager.store(self.favourites, to: .caches, as: StorageKeys.favouriteLines)
    }
    
    public func getLines() {
        guard let delegate = self.observer else { return }
        if StorageManager.fileExists(StorageKeys.urbanLines, in: .caches) && StorageManager.fileExists(StorageKeys.suburbanLines, in: .caches){
            self.urbanLines = StorageManager.retrieve(StorageKeys.urbanLines, from: .caches, as: [Line].self)
            self.suburbanLines = StorageManager.retrieve(StorageKeys.suburbanLines, from: .caches, as: [Line].self)
            delegate.refreshUI()
        } else {
            delegate.showLoader()
        }
    }
}
