//
//  AddLinesViewModelTest.swift
//  BusNSTests
//
//  Created by Marko Popić on 11/12/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import XCTest
@testable import BusNS

class AddLinesViewModelTest: XCTestCase {

    let lineViewModel = AddLinesViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_changeType_urban() {
        lineViewModel.changeLineType(isTypeUrban: true)
        XCTAssertTrue(lineViewModel.isTypeUrban)
    }
    
    func test_changeType_suburban() {
        lineViewModel.changeLineType(isTypeUrban: false)
        XCTAssertFalse(lineViewModel.isTypeUrban)
    }
}
