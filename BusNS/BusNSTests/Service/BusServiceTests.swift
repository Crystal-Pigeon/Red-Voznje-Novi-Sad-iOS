//
//  BusServiceTests.swift
//  BusNSTests
//
//  Created by Mariana Samardzic on 19.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation
import XCTest
@testable import Red_Vožnje___Novi_Sad

class BusServiceTests: XCTestCase {
    
    // MARK: - No internet
    func testNoInternet() {
        let networkManager = NetworkManagerMock(networkManagerType: .offline)
        let busService = BusService(networkManager: networkManager)
        busService.getBus(type: "test", id: "1") { (buses, error) in
            XCTAssertEqual(error, ServiceError.internetError)
        }
    }
    
    // MARK: - Failed request
    func testRequestFailed() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let network = NetworkMock(networkType: .failed)
        let busService = BusService(networkManager: networkManager, network: network)
        busService.getBus(type: "test", id: "1") { (buses, error) in
            XCTAssertEqual(error, ServiceError.internetError)
        }
    }
    
    // MARK: - Wrong status code
    func testStatusCodeWrongNoData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let network = NetworkMock(networkType: .statusCodeFailed)
        let busService = BusService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        busService.getBus(type: "test", id: "1") { (buses, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func testStatusCodeWrongDataBadFormat() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let errorMessage = ["someKey": 1]
        let network = NetworkMock(networkType: .statusCodeMessageBadFormat, errorMessage: errorMessage)
        let busService = BusService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        busService.getBus(type: "test", id: "1") { (buses, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func testStatusCodeWrongData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let errorMessage = ["message": "Test error"]
        let network = NetworkMock(networkType: .statusCodeMessage, errorMessage: errorMessage)
        let busService = BusService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Test error")
        busService.getBus(type: "test", id: "1") { (buses, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    // MARK: - Wrong data
    func testNoData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let network = NetworkMock(networkType: .noData)
        let busService = BusService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        busService.getBus(type: "test", id: "1") { (buses, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func testWrongData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let data = [["someKey": "someData"]]
        let network = NetworkMock(networkType: .dataBadFormat, data: data)
        let busService = BusService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        busService.getBus(type: "test", id: "1") { (buses, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    // MARK: - Success
    func testCorrectNoError() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let data = [[
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": [
                "11": [
                    "00"
                ],
                "13": [
                    "05"
                ],
                "14": [
                    "10"
                ],
                "15": [
                    "15"
                ],
                "16": [
                    "20"
                ],
                "17": [
                    "25"
                ],
                "18": [
                    "30"
                ],
                "19": [
                    "35"
                ],
                "23": [
                    "40"
                ],
                "05": [
                    "30"
                ],
                "06": [
                    "35"
                ],
                "09": [
                    "00"
                ]
            ],
            "rasporedB": [
                "11": [
                    "30"
                ],
                "13": [
                    "35"
                ],
                "14": [
                    "40"
                ],
                "15": [
                    "45"
                ],
                "16": [
                    "50"
                ],
                "17": [
                    "55"
                ],
                "19": [
                    "00"
                ],
                "20": [
                    "05"
                ],
                "04": [
                    "55"
                ],
                "06": [
                    "00"
                ],
                "07": [
                    "05"
                ],
                "09": [
                    "30"
                ]
            ],
        "dodaci": "IL=IZ LIRA, LIR=ZA LIR" ]]
        let network = NetworkMock(networkType: .correct, data: data)
        let busService = BusService(networkManager: networkManager, network: network)
        busService.getBus(type: "test", id: "1") { (buses, error) in
            XCTAssertNil(error)
        }
    }
    
    func testCorrectHasData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let data = [[
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": [
                "11": [
                    "00"
                ],
                "13": [
                    "05"
                ],
                "14": [
                    "10"
                ],
                "15": [
                    "15"
                ],
                "16": [
                    "20"
                ],
                "17": [
                    "25"
                ],
                "18": [
                    "30"
                ],
                "19": [
                    "35"
                ],
                "23": [
                    "40"
                ],
                "05": [
                    "30"
                ],
                "06": [
                    "35"
                ],
                "09": [
                    "00"
                ]
            ],
            "rasporedB": [
                "11": [
                    "30"
                ],
                "13": [
                    "35"
                ],
                "14": [
                    "40"
                ],
                "15": [
                    "45"
                ],
                "16": [
                    "50"
                ],
                "17": [
                    "55"
                ],
                "19": [
                    "00"
                ],
                "20": [
                    "05"
                ],
                "04": [
                    "55"
                ],
                "06": [
                    "00"
                ],
                "07": [
                    "05"
                ],
                "09": [
                    "30"
                ]
            ],
        "dodaci": "IL=IZ LIRA, LIR=ZA LIR" ]]
        let network = NetworkMock(networkType: .correct, data: data)
        let busService = BusService(networkManager: networkManager, network: network)
        busService.getBus(type: "test", id: "1") { (buses, error) in
            XCTAssertNotNil(buses)
        }
    }
}
