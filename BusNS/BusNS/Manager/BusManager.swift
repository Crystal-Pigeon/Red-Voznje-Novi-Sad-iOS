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
    public static var fetchLinesFlag = false
    public static var numberOfFetchedLines = 0 {
        didSet {
            if numberOfFetchedLines == 0 { return }
            guard let viewModel = self.linesViewModel else { return }
            viewModel.refreshLines()
            if fetchLinesFlag { viewModel.fetchedAll() }
            fetchLinesFlag = true
        }
    }
    public static var wasOnLinesScreen = false
    
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
    
    public static var isFetchedAll: Bool {
        return numberOfFetchedLines == numberOfFetchedBuses
    }
    
    public static func didNotFetchAll() {
        self.numberOfFetchedBuses = 0
        self.numberOfFetchedLines = 0
        guard let viewModel = self.linesViewModel else { return }
        viewModel.didNotFetchAll()
    }
    
    public static func storeFavorites() {
        StorageManager.shared.store(self.favorites, to: .caches, as: path)
    }
    
    public static func retriveFavorites() {
        if StorageManager.shared.fileExists(path, in: .caches) {
            self.favorites = StorageManager.shared.retrieve(path, from: .caches, as: [String].self)
        }
    }
    
    public static func getBusBy(id: String) -> [Bus]? {
        if !StorageManager.shared.fileExists(StorageKeys.bus + id, in: .caches) { return nil }
        return StorageManager.shared.retrieve(StorageKeys.bus + id, from: .caches, as: [Bus].self)
    }
}
