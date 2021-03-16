//
//  SeasonServiceTests.swift
//  BusNSTests
//
//  Created by Mariana Samardzic on 16.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import XCTest

@testable import Red_Vožnje___Novi_Sad

class SeasonServiceNoInternetTests: XCTestCase {

    let seasonService = SeasonService.testOffline
    
    func testNoInternetHasError() {
        seasonService.getSeason { (seasons, error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testNoInternetMessage() {
        seasonService.getSeason { (seasons, error) in
            XCTAssertEqual(error?.message, "No internet connection".localized())
        }
    }
}
