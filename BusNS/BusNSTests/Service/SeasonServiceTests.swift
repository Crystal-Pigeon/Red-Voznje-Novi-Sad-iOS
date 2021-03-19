//
//  SeasonServiceTests.swift
//  BusNSTests
//
//  Created by Mariana Samardzic on 19.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation
import XCTest
@testable import Red_Vožnje___Novi_Sad

class SeasonServiceTests: XCTestCase {
    
    // MARK: - No internet
    func testNoInternet() {
        let networkManager = NetworkManagerMock(networkManagerType: .offline)
        let seasonService = SeasonService(networkManager: networkManager)
        seasonService.getSeason { (seasons, error) in
            XCTAssertEqual(error, ServiceError.internetError)
        }
    }
    
    // MARK: - Failed request
    func testRequestFailed() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let network = NetworkMock(networkType: .failed)
        let seasonService = SeasonService(networkManager: networkManager, network: network)
        seasonService.getSeason { (seasons, error) in
            XCTAssertEqual(error, ServiceError.internetError)
        }
    }
    
    // MARK: - Wrong status code
    func testStatusCodeWrongNoData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let network = NetworkMock(networkType: .statusCodeFailed)
        let seasonService = SeasonService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        seasonService.getSeason { (seasons, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func testStatusCodeWrongDataBadFormat() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let errorMessage = ["someKey": 1]
        let network = NetworkMock(networkType: .statusCodeMessageBadFormat, errorMessage: errorMessage)
        let seasonService = SeasonService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        seasonService.getSeason { (seasons, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func testStatusCodeWrongData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let errorMessage = ["message": "Test error"]
        let network = NetworkMock(networkType: .statusCodeMessage, errorMessage: errorMessage)
        let seasonService = SeasonService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Test error")
        seasonService.getSeason { (seasons, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    // MARK: - Wrong data
    func testNoData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let network = NetworkMock(networkType: .noData)
        let seasonService = SeasonService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        seasonService.getSeason { (seasons, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func testWrongData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let data = [["someKey": "someData"]]
        let network = NetworkMock(networkType: .dataBadFormat, data: data)
        let seasonService = SeasonService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        seasonService.getSeason { (seasons, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    // MARK: - Success
    func testCorrectNoError() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let data = [["datum": "02.12.1997", "redv": "test"]]
        let network = NetworkMock(networkType: .correct, data: data)
        let seasonService = SeasonService(networkManager: networkManager, network: network)
        seasonService.getSeason { (seasons, error) in
            XCTAssertNil(error)
        }
    }
    
    func testCorrectHasData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let data = [["datum": "02.12.1997", "redv": "test"]]
        let network = NetworkMock(networkType: .correct, data: data)
        let seasonService = SeasonService(networkManager: networkManager, network: network)
        seasonService.getSeason { (seasons, error) in
            XCTAssertNotNil(seasons)
        }
    }
}
