//
//  RearrangeFavoritesViewModel.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/25/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

class RearrangeFavoritesViewModel {
    var favorites: [String] { DatabaseManager.shared.favorites }
    
    func getBusNameBy(id: String) -> String {
        guard let bus = DatabaseManager.shared.getBusBy(id: id).first else { return "" }
        return bus.fullName
    }
    
    func rearrange(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath){
        let movedObject = favorites[sourceIndexPath.row]
        DatabaseManager.shared.removeFavorite(id: movedObject)
        DatabaseManager.shared.insertFavorite(id: movedObject, at: destinationIndexPath.row)
    }
}
