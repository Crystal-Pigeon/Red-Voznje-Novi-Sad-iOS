//
//  LineServiceTests.swift
//  BusNSTests
//
//  Created by Mariana Samardzic on 19.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation
import XCTest
@testable import Red_Vožnje___Novi_Sad

class LineServiceTests: XCTestCase {
    
    // MARK: - No internet
    func testNoInternet() {
        let networkManager = NetworkManagerMock(networkManagerType: .offline)
        let lineService = LineService(networkManager: networkManager)
        lineService.getLines(type: "test") { (lines, error) in
            XCTAssertEqual(error, ServiceError.internetError)
        }
    }
    
    // MARK: - Failed request
    func testRequestFailed() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let network = NetworkMock(networkType: .failed)
        let lineService = LineService(networkManager: networkManager, network: network)
        lineService.getLines(type: "test") { (lines, error) in
            XCTAssertEqual(error, ServiceError.internetError)
        }
    }
    
    // MARK: - Wrong status code
    func testStatusCodeWrongNoData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let network = NetworkMock(networkType: .statusCodeFailed)
        let lineService = LineService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        lineService.getLines(type: "test") { (lines, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func testStatusCodeWrongDataBadFormat() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let errorMessage = ["someKey": 1]
        let network = NetworkMock(networkType: .statusCodeMessageBadFormat, errorMessage: errorMessage)
        let lineService = LineService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        lineService.getLines(type: "test") { (lines, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func testStatusCodeWrongData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let errorMessage = ["message": "Test error"]
        let network = NetworkMock(networkType: .statusCodeMessage, errorMessage: errorMessage)
        let lineService = LineService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Test error")
        lineService.getLines(type: "test") { (lines, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    // MARK: - Wrong data
    func testNoData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let network = NetworkMock(networkType: .noData)
        let lineService = LineService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        lineService.getLines(type: "test") { (lines, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    func testWrongData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let data = [["someKey": "someData"]]
        let network = NetworkMock(networkType: .dataBadFormat, data: data)
        let lineService = LineService(networkManager: networkManager, network: network)
        let expectedError = ServiceError(message: "Problem with server".localized())
        lineService.getLines(type: "test") { (lines, error) in
            XCTAssertEqual(error, expectedError)
        }
    }
    
    // MARK: - Success
    func testCorrectNoError() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let data = [["id":"1", "broj": "1", "linija": "test"]]
        let network = NetworkMock(networkType: .correct, data: data)
        let lineService = LineService(networkManager: networkManager, network: network)
        lineService.getLines(type: "test") { (lines, error) in
            XCTAssertNil(error)
        }
    }
    
    func testCorrectHasData() {
        let networkManager = NetworkManagerMock(networkManagerType: .online)
        let data = [["id":"1", "broj": "1", "linija": "test"]]
        let network = NetworkMock(networkType: .correct, data: data)
        let lineService = LineService(networkManager: networkManager, network: network)
        lineService.getLines(type: "test") { (lines, error) in
            XCTAssertNotNil(lines)
        }
    }
}

