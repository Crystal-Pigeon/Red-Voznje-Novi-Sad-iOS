//
//  MainViewModel.swift
//  BusNS
//
//  Created by Mariana Samardzic on 14/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

protocol  MainObserver {
    func refreshUI()
    func refreshCell(busID: String)
    func showError(message: String)
}

class MainViewModel {
    public var observer: MainObserver?
    
    public private(set) var currentSeason: Season?
    public private(set) var urbanLines = [Line]()
    public private(set) var suburbanLines = [Line]()
    public var favorites: [String] {
        get {
            return BusManager.favorites
        }
        set {
            BusManager.favorites = newValue
        }
    }
    public let tagsDict = [0:"R", 1: "S", 2: "N"]
    private var lastCount = BusManager.favorites.count
    private var urbanBuses = [[Bus]]()
    private var suburbanBuses = [[Bus]]()
    
    init(){
        BusManager.mainViewModel = self
    }
    
    public func resetLastCount() {
        lastCount = BusManager.favorites.count
    }
    
    public func shouldSetNeedsLayout() -> Bool {
        return (lastCount == 0 && favorites.count != 0) || (lastCount != 0 && favorites.count == 0)
    }
    
    public func getBusNameBy(id: String) -> String {
        guard let bus = BusManager.getBusBy(id: id)?.first else { return "" }
        return bus.number + " " + bus.name
    }
    
    public func getData() {
        if !NetworkManager.shared.isInternetAvailable() {
            if StorageManager.fileExists(StorageKeys.season, in: .caches) {
                self.currentSeason = StorageManager.retrieve(StorageKeys.season, from: .caches, as: Season.self)
                return
            }
            else {
                guard let delegate = self.observer else { return }
                delegate.showError(message: "No internet connection".localized())
            }
        }
        else {
            self.fetchSeason()
        }
    }
    
    private func fetchSeason() {
        SeasonService.self.shared.getSeason { (seasons, error) in
            guard let delegate = self.observer else { return }
            if let error = error {
                delegate.showError(message: error.message)
                BusManager.didNotFetchAll()
                return
            }
            if let seasons = seasons{
                let newSeason = seasons[0]
                let oldSeason: Season?
                if StorageManager.fileExists(StorageKeys.season, in: .caches) {
                    oldSeason = StorageManager.retrieve(StorageKeys.season, from: .caches, as: Season.self)
                } else {
                    oldSeason = nil
                }
                self.currentSeason = newSeason
                guard newSeason != oldSeason else { return }
                
                self.fetchUrbanLines()
                self.fetchSuburbanLines()
                
            }
        }
    }
    
    private func fetchUrbanLines() {
        LineService.shared.getUrbanLines { (lines, error) in
            guard let delegate = self.observer else { return }
            if let error = error {
                delegate.showError(message: error.message)
                BusManager.didNotFetchAll()
                return
            }
            if let lines = lines {
                self.urbanLines = lines
                BusManager.numberOfFetchedLines += lines.count
                
                let favouriteUrban = self.urbanLines.filter { self.favorites.contains($0.id)}
                favouriteUrban.forEach { line in
                    self.fetchUrbanBus(line: line, isFavourite: true)
                }
                
                let notFavouriteUrban = self.urbanLines.filter{ !self.favorites.contains($0.id)}
                notFavouriteUrban.forEach { line in
                    self.fetchUrbanBus(line: line, isFavourite: false)
                }
            }
        }
    }
    
    private func fetchSuburbanLines() {
        LineService.shared.getSuburbanLines { (lines, error) in
            guard let delegate = self.observer else { return }
            if let error = error {
                delegate.showError(message: error.message)
                BusManager.didNotFetchAll()
                return
            }
            if let lines = lines {
                self.suburbanLines = lines
                BusManager.numberOfFetchedLines += lines.count
                
                let favouriteSuburban = self.suburbanLines.filter { self.favorites.contains($0.id)}
                favouriteSuburban.forEach { line in
                    self.fetchSuburbanBus(line: line, isFavourite: true)
                }
                
                let notFavouriteSuburban = self.suburbanLines.filter{ !self.favorites.contains($0.id)}
                notFavouriteSuburban.forEach { line in
                    self.fetchSuburbanBus(line: line, isFavourite: false)
                }
            }
        }
    }
    
    private func fetchUrbanBus(line: Line, isFavourite: Bool) {
        guard let delegate = self.observer else { return }
        let id = line.id
        BusService.shared.getUrbanBus(id: id) { (buses, error) in
            if let error = error {
                delegate.showError(message: error.message)
                BusManager.didNotFetchAll()
                return
            }
            if let buses = buses {
                self.urbanBuses.append(buses)
                BusManager.numberOfFetchedBuses += 1
                if isFavourite {
                    delegate.refreshCell(busID: id)
                }
            }
        }
    }
    
    private func fetchSuburbanBus(line: Line, isFavourite: Bool) {
        guard let delegate = self.observer else { return }
        let id = line.id
        BusService.shared.getSuburbanBus(id: id) { (buses, error) in
            if let error = error {
                delegate.showError(message: error.message)
                BusManager.didNotFetchAll()
                return
            }
            if let buses = buses {
                self.suburbanBuses.append(buses)
                BusManager.numberOfFetchedBuses += 1
                if isFavourite {
                    delegate.refreshCell(busID: id)
                }
            }
        }
    }
    
    public func fetchedAll() {
        StorageManager.store(self.currentSeason, to: .caches, as: StorageKeys.season)
        StorageManager.store(self.urbanLines, to: .caches, as: StorageKeys.urbanLines)
        StorageManager.store(self.suburbanLines, to: .caches, as: StorageKeys.suburbanLines)
        for bus in self.urbanBuses {
            guard let first = bus.first else { return }
            let sk = StorageKeys.bus + "\(first.id)"
            StorageManager.store(bus, to: .caches, as: sk)
        }
        for bus in self.suburbanBuses {
            guard let first = bus.first else { return }
            let sk = StorageKeys.bus + "\(first.id)"
            StorageManager.store(bus, to: .caches, as: sk)
        }
    }
}
