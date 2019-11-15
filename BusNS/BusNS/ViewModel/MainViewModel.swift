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
    func showError(message: String)
}

class MainViewModel {
    public var observer: MainObserver?
    
    public private(set) var currentSeason: Season?
    public private(set) var urbanLines = [Line]()
    public private(set) var suburbanLines = [Line]()
    public private(set) var suburbanBuses = [String:[Bus]]()
    public private(set) var urbanBuses = [String: [Bus]]()
    
    init(){}
    
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
                
                StorageManager.store(self.currentSeason, to: .caches, as: StorageKeys.season)
                self.fetchLines()
                
            }
        }
    }
    
    private func fetchLines() {
        self.fetchUrbanLines()
        self.fetchSuburbanLines()
    }
    
    private func fetchUrbanLines() {
        LineService.shared.getUrbanLines { (lines, error) in
            guard let delegate = self.observer else { return }
            if let error = error {
                delegate.showError(message: error.message)
                return
            }
            if let lines = lines {
                self.urbanLines = lines
                StorageManager.store(self.urbanLines, to: .caches, as: StorageKeys.urbanLines)
                self.fetchUrbanBuses()
            }
        }
    }
    
    private func fetchSuburbanLines() {
        LineService.shared.getSuburbanLines { (lines, error) in
            guard let delegate = self.observer else { return }
            if let error = error {
                delegate.showError(message: error.message)
                return
            }
            if let lines = lines {
                self.suburbanLines = lines
                StorageManager.store(self.suburbanLines, to: .caches, as: StorageKeys.suburbanLines)
                self.fetchSuburbanBuses()
            }
        }
    }
    
    private func fetchUrbanBuses() {
        guard let delegate = self.observer else { return }
        self.urbanLines.forEach { line in
            let id = line.id
            BusService.shared.getUrbanBus(id: id) { (buses, error) in
                if let error = error {
                    delegate.showError(message: error.message)
                    return
                }
                if let buses = buses {
                    let sk = StorageKeys.bus + "\(id)"
                    StorageManager.store(buses, to: .caches, as: sk)
                    self.urbanBuses[id] = buses
                }
            }
        }
    }
    
    private func fetchSuburbanBuses() {
        guard let delegate = self.observer else { return }
        self.suburbanLines.forEach { line in
            let id = line.id
            BusService.shared.getSuburbanBus(id: id) { (buses, error) in
                if let error = error {
                    delegate.showError(message: error.message)
                    return
                }
                if let buses = buses {
                    let sk = StorageKeys.bus + "\(id)"
                    StorageManager.store(buses, to: .caches, as: sk)
                    self.suburbanBuses[id] = buses
                }
            }
        }
    }
}
