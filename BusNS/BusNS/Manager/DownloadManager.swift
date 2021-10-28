//
//  DownloadManager.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation
import UIKit

protocol DownloadObserver {
    func downloaderDidFinish()
}

public class DownloadManager {
    
    public static var shared = DownloadManager()
    
    private init() {}
    
    private var viewController: UIViewController? {
        UIApplication.topViewController()
    }
    
    private var observers = [DownloadObserver]()
    private var numberOfDownloadedLines: Int = 0
    private var numberOfDownloadedBuses: Int = 0 {
        didSet {
            if numberOfDownloadedBuses == numberOfDownloadedLines {
                self.viewController?.removeActivityLoader()
                self.viewController?.showSnackbar("Everything is up to date".localized())
                if let season = self.newSeason {
                    DatabaseManager.shared.season = season
                }
                self.notifyObservers()
            }
        }
    }
    private var newSeason: Season?
    
    func checkSeason() {
        if !NetworkManager.shared.isInternetAvailable() { return }
        SeasonService.self.shared.getSeason { (seasons, error) in
            if let seasons = seasons, let newSeason = seasons.first {
                self.newSeason = newSeason
                if let storedSeason = DatabaseManager.shared.season {
                    if storedSeason == newSeason {//if storedSeason == Season(date: "10.10.2021.", season: "JESEN 2021") {
                        self.viewController?.showSnackbar("Everything is up to date".localized())
                        return
                    }
                    
                    //Dosupan je novi raspored
                    self.viewController?.showChooseAlert(title: "new_season_title".localized(), message: "new_season_message".localized(), cancel: "Cancel".localized(), option: "new_season_action".localized(), completion: {
                        self.downloadData()
                    })
                    return
                }
                
                //Nema keširanih podataka, dovuci podatke
                self.downloadData()
            }
        }
    }
    
    func downloadData() {
        self.viewController?.showActivityLoader()
        self.downloadUrbanLines()
        self.downloadSuburbanLines()
    }
    
    func downloadUrbanLines() {
        LineService.shared.getUrbanLines { (lines, error) in
            if error != nil {
                self.viewController?.showErrorAlert(message: error!.message, completion: {
                    self.viewController?.removeActivityLoader()
                })
                return
            }
            guard let lines = lines else { return }
            print("GET: Urban Lines")
            print(lines)
            DatabaseManager.shared.urbanLines = lines
            lines.forEach { line in
                self.downloadUrbanBus(id: line.id)
            }
            self.numberOfDownloadedLines += lines.count
        }
    }
    
    func downloadSuburbanLines() {
        LineService.shared.getSuburbanLines { (lines, error) in
            if error != nil {
                self.viewController?.showErrorAlert(message: error!.message, completion: {
                    self.viewController?.removeActivityLoader()
                })
                return
            }
            guard let lines = lines else { return }
            print("GET: Suburban Lines")
            print(lines)
            DatabaseManager.shared.suburbanLines = lines
            lines.forEach { line in
                self.downloadSuburbanBus(id: line.id)
            }
            self.numberOfDownloadedLines += lines.count
        }
    }
    
    private func downloadUrbanBus(id: String) {
        BusService.shared.getUrbanBus(id: id) { (buses, error) in
            if error != nil {
                self.viewController?.showErrorAlert(message: error!.message, completion: {
                    self.viewController?.removeActivityLoader()
                })
                return
            }
            guard let buses = buses else { return }
            print("GET: Urban Bus \(id)")
            print(buses)
            DatabaseManager.shared.setBus(buses, id: id)
            self.numberOfDownloadedBuses += 1
        }
    }
    
    private func downloadSuburbanBus(id: String) {
        BusService.shared.getSuburbanBus(id: id) { (buses, error) in
            if error != nil {
                self.viewController?.showErrorAlert(message: error!.message, completion: {
                    self.viewController?.removeActivityLoader()
                })
                return
            }
            guard let buses = buses else { return }
            print(buses)
            DatabaseManager.shared.setBus(buses, id: id)
            self.numberOfDownloadedBuses += 1
        }
    }
    
    func addObserver(_ observer: DownloadObserver) {
        self.observers.append(observer)
    }
    
    private func notifyObservers() {
        self.observers.forEach { observer in
            observer.downloaderDidFinish()
        }
    }
}
