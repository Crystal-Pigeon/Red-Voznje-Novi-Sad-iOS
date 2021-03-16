//
//  SeasonTests.swift
//  BusNSTests
//
//  Created by Mariana Samardzic on 13/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

import XCTest
@testable import Red_Vožnje___Novi_Sad

class SeasonTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_jsonDecode() {
        let json = """
            {
                "datum": "2019-10-12",
                "redv": "ZIMA3 2019"
            }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let season = try! decoder.decode(Season.self, from: json)
        XCTAssertNotNil(season)
    }
    
    func test_allEqual() {
        let json = """
        {
            "datum": "2019-10-12",
            "redv": "ZIMA3 2019"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let season = try! decoder.decode(Season.self, from: json)
        XCTAssertEqual(season, Season(date: "2019-10-12", season: "ZIMA3 2019"))
    }

    func test_dateNotEqual() {
        let json = """
        {
            "datum": "2019-10-12",
            "redv": "ZIMA3 2019"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let season = try! decoder.decode(Season.self, from: json)
        XCTAssertNotEqual(season, Season(date: "", season: "ZIMA3 2019"))
    }

    func test_seasonNotEqual() {
        let json = """
        
        {
            "datum": "2019-10-12",
            "redv": "ZIMA3 2019"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let season = try! decoder.decode(Season.self, from: json)
        XCTAssertNotEqual(season, Season(date: "2019-10-12", season: ""))
    }
}
