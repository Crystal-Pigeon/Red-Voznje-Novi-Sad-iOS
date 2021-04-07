//
//  LineTests.swift
//  BusNSTests
//
//  Created by Marko Popić on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import XCTest
@testable import Red_Voznje___Novi_Sad

class LineTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_jsonDecode() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "linija": "VETERNIK"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let line = try! decoder.decode(Line.self, from: json)
        XCTAssertNotNil(line)
    }
    
    func test_allEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "linija": "VETERNIK"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let line = try! decoder.decode(Line.self, from: json)
        XCTAssertEqual(line, Line(id: "52", number: "52", name: "VETERNIK"))
    }
    
    func test_idNotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "linija": "VETERNIK"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let line = try! decoder.decode(Line.self, from: json)
        XCTAssertNotEqual(line, Line(id: "", number: "52", name: "VETERNIK"))
    }
    
    func test_numberNotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "linija": "VETERNIK"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let line = try! decoder.decode(Line.self, from: json)
        XCTAssertNotEqual(line, Line(id: "52", number: "", name: "VETERNIK"))
    }
    
    func test_nameNotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "linija": "VETERNIK"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let line = try! decoder.decode(Line.self, from: json)
        XCTAssertNotEqual(line, Line(id: "52", number: "52", name: ""))
    }
}
