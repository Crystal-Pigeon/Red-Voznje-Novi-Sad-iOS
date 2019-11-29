//
//  BusManager.swift
//  BusNS
//
//  Created by Marko Popić on 11/22/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

class BusManager {
    
    private static let path = StorageKeys.favorites
    public static var favorites = [String]()
    public static var linesViewModel: AddLinesViewModel?
    public static var mainViewModel: MainViewModel?
    public static var numberOfFetchedLines = 0 {
        didSet {
            if numberOfFetchedLines == 0 { return }
            guard let viewModel = self.linesViewModel else { return }
            viewModel.refreshLines()
        }
    }
    
    public static var numberOfFetchedBuses = 0 {
        didSet {
            if numberOfFetchedLines == numberOfFetchedBuses {
                if let viewModel = self.mainViewModel {
                    viewModel.fetchedAll()
                }
                guard let viewModel = self.linesViewModel else { return }
                viewModel.fetchedAll()
            }
        }
    }
    
    public static var didFetchAll: Bool {
        return numberOfFetchedLines == numberOfFetchedBuses
    }
    
    public static func didNotFetchAll() {
        guard let viewModel = self.linesViewModel else { return }
        viewModel.didNotFetchAll()
    }
    
    public static func storeFavorites() {
        StorageManager.store(self.favorites, to: .caches, as: path)
    }
    
    public static func retriveFavorites() {
        if StorageManager.fileExists(path, in: .caches) {
            self.favorites = StorageManager.retrieve(path, from: .caches, as: [String].self)
        }
    }
    
    public static func getBusBy(id: String) -> [Bus]? {
        if !StorageManager.fileExists(StorageKeys.bus + id, in: .caches) { return nil }
        return StorageManager.retrieve(StorageKeys.bus + id, from: .caches, as: [Bus].self)
    }
}
