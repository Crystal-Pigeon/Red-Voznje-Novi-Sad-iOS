//
//  RearrangeFavoritesViewModel.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/25/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

class RearrangeFavoritesViewModel {
    public private(set) var favorites: [String] {
        get {
            return BusManager.favorites
        }
        set {
            BusManager.favorites = newValue
        }
    }
    
    public func getBusNameBy(id: String) -> String {
        guard let bus = BusManager.getBusBy(id: id)?.first else { return "" }
        return bus.number + " " + bus.name
    }
    
    public func rearrange(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath){
        let movedObject = favorites[sourceIndexPath.row]
        favorites.remove(at: sourceIndexPath.row)
        favorites.insert(movedObject, at: destinationIndexPath.row)
        BusManager.storeFavorites()
    }
}
