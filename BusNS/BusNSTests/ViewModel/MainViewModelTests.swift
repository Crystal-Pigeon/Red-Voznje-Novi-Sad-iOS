//
//  MainViewModelTests.swift
//  BusNSTests
//
//  Created by Mariana Samardzic on 19.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation
import XCTest
@testable import Red_Vožnje___Novi_Sad

class MainObserverMock: MainObserver {
    
    // expectation
    public let showErrorExpectation = XCTestExpectation(description: "show error")
    public let refreshUIExpectation = XCTestExpectation(description: "refresh UI")
    public let refreshCellExpectation = XCTestExpectation(description: "refresh cell")
    public let showToastExcpecation = XCTestExpectation(description: "show toast")
    
    // methods
    func refreshUI() {
        refreshUIExpectation.fulfill()
    }
    
    func refreshCell(busID: String) {
        refreshCellExpectation.fulfill()
    }
    
    func showError(message: String) {
        showErrorExpectation.fulfill()
    }
    
    func showToast() {
        showToastExcpecation.fulfill()
    }
}

class MainViewModelTest: XCTestCase {
    
    // data
    let season = ["datum": "02.12.1997", "redv": "test"]
    
    // network managers
    let onlineNetworkManager = NetworkManagerMock(networkManagerType: .online)
    let offlineNetworkManager = NetworkManagerMock(networkManagerType: .offline)
    
    // storage managers
    let noDataStorage = StorageMock()
    var hasDataStorage: StorageMock!
    
    // observer
    let observer = MainObserverMock()
    
    // network
    var correctNetwork: NetworkMock!
    let failedNetwork = NetworkMock(networkType: .failed)
    
    override func setUp() {
        self.hasDataStorage = StorageMock(data: season)
        self.correctNetwork = NetworkMock(networkType: .correct, errorMessage: nil, data: [season])
    }
    
    func testGetDataNoInternetNoCached() {
        let mainViewModel = MainViewModel(networkManager: offlineNetworkManager, storageManager: noDataStorage)
        mainViewModel.observer = observer
        
        mainViewModel.getData()
        wait(for: [observer.showErrorExpectation], timeout: 10.0)
    }
    
    func testGetDataNoInternetCached() {
        let mainViewModel = MainViewModel(networkManager: offlineNetworkManager, storageManager: hasDataStorage)
        mainViewModel.observer = observer
        
        mainViewModel.getData()
        XCTAssertEqual(mainViewModel.currentSeason, Season(date: "02.12.1997", season: "test"))
    }
    
    func testError() {
        let seasonService = SeasonService(networkManager: onlineNetworkManager, network: failedNetwork)
        let mainViewModel = MainViewModel(networkManager: onlineNetworkManager, storageManager: noDataStorage, seasonService: seasonService)
        mainViewModel.observer = observer
        mainViewModel.getData()
        wait(for: [observer.showErrorExpectation], timeout: 10.0)
    }
    
    func testSameSeason() {
        let seasonService = SeasonService(networkManager: onlineNetworkManager, network: correctNetwork)
        let mainViewModel = MainViewModel(networkManager: onlineNetworkManager, storageManager: hasDataStorage, seasonService: seasonService)
        mainViewModel.observer = observer
        mainViewModel.getData()
        wait(for: [observer.showToastExcpecation], timeout: 10.0)
    }
}
