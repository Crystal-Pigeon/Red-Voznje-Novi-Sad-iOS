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
    public private(set) var isTypeUrban = true
    public private(set) var lines = [Line]()
    
    init() {}
    
    public func addToFavourites(id: String){
        if let index = favourites.firstIndex(of: id) {
            favourites.remove(at: index)
        } else {
            favourites.append(id)
        }
        StorageManager.store(self.favourites, to: .caches, as: StorageKeys.favouriteLines)
    }
    
    public func changeLineType(isTypeUrban: Bool) {
        self.isTypeUrban = isTypeUrban
        lines = self.isTypeUrban ? urbanLines : suburbanLines
        guard let delegate = self.observer else { return }
        delegate.refreshUI()
    }
    
    public func getLines() {
        if StorageManager.fileExists(StorageKeys.urbanLines, in: .caches) && StorageManager.fileExists(StorageKeys.suburbanLines, in: .caches){
            self.urbanLines = StorageManager.retrieve(StorageKeys.urbanLines, from: .caches, as: [Line].self)
            self.suburbanLines = StorageManager.retrieve(StorageKeys.suburbanLines, from: .caches, as: [Line].self)
            self.lines = self.urbanLines
        } else {
            guard let delegate = self.observer else { return }
            delegate.showLoader()
        }
    }
}
