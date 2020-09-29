//
//  BusTests.swift
//  BusNSTests
//
//  Created by Mariana Samardzic on 13/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

import XCTest
@testable import BusNS

class BusTests: XCTestCase {

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
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        XCTAssertNotNil(bus)
    }
    
    func test_allEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK",line: nil, day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR")
        XCTAssertEqual(bus,busNew)
    }
    func test_idNotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil,day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]],schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR")
        XCTAssertNotEqual(bus,busNew)
    }
    
    func test_numberNotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "52", number: "", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK",  line: nil,day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR")
        XCTAssertNotEqual(bus,busNew)
    }
    
    func test_nameNotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "52", number: "52", name: "", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil, day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR")
        XCTAssertNotEqual(bus,busNew)
    }
    func test_lineANotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "52", number: "52", name: "VETERNIK", lineA: "", lineB: "Polasci iz  VETERNIK", line: nil, day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR")
        XCTAssertNotEqual(bus,busNew)
    }
    func test_lineBNotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "", line: nil,day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR")
        XCTAssertNotEqual(bus,busNew)
    }
    func test_lineNotEqual() {
        let json = """
        {
            "id": "7A.",
            "broj": "7A",
            "naziv": "N.NASELJE-Z.STAN-F.PIJA-LIMAN4-N.NASELJE",
            "linija": "N.NASELJE - Z.STAN - F.PIJA - LIMAN4 - N.NASELJE",
            "dan": "S",
            "raspored": {
                "10": [
                    "00",
                    "13",
                    "25",
                    "38",
                    "50"
                ],
                "11": [
                    "03",
                    "15",
                    "28",
                    "40",
                    "53"
                ],
                "12": [
                    "05",
                    "18",
                    "30",
                    "43",
                    "55"
                ],
                "13": [
                    "11",
                    "28",
                    "45"
                ],
                "14": [
                    "01",
                    "18",
                    "35",
                    "51"
                ],
                "15": [
                    "08",
                    "25",
                    "41",
                    "58"
                ],
                "16": [
                    "15",
                    "31",
                    "48"
                ],
                "17": [
                    "05",
                    "21",
                    "38",
                    "55"
                ],
                "18": [
                    "11",
                    "28",
                    "45"
                ],
                "19": [
                    "01",
                    "18",
                    "35",
                    "51"
                ],
                "20": [
                    "08",
                    "25",
                    "41",
                    "58"
                ],
                "21": [
                    "15",
                    "31",
                    "48"
                ],
                "22": [
                    "05",
                    "24",
                    "48"
                ],
                "23": [
                    "12",
                    "36"
                ],
                "04": [
                    "30"
                ],
                "05": [
                    "00",
                    "25",
                    "50"
                ],
                "06": [
                    "07",
                    "24",
                    "40",
                    "53"
                ],
                "07": [
                    "05",
                    "18",
                    "30",
                    "43",
                    "55"
                ],
                "08": [
                    "08",
                    "20",
                    "33",
                    "45",
                    "58"
                ],
                "09": [
                    "10",
                    "23",
                    "35",
                    "48"
                ],
                "00": [
                    "00"
                ]
            },
            "dodaci": "CRVENO - NISKOPODNI, ZELENO PODVUČENO - NISKOPODNI SA RAMPOM"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode(Bus.self, from: json)
        let busNew = Bus(id: "7A.", number: "7A", name: "N.NASELJE-Z.STAN-F.PIJA-LIMAN4-N.NASELJE", lineA: nil, lineB: nil, line: "", day: "S", scheduleA: nil, scheduleB: nil, schedule: ["16": ["15", "31", "48"], "13": ["11", "28", "45"], "07": ["05", "18", "30", "43", "55"], "10": ["00", "13", "25", "38", "50"], "15": ["08", "25", "41", "58"], "00": ["00"], "09": ["10", "23", "35", "48"], "23": ["12", "36"], "18": ["11", "28", "45"], "17": ["05", "21", "38", "55"], "05": ["00", "25", "50"], "08": ["08", "20", "33", "45", "58"], "21": ["15", "31", "48"], "04": ["30"], "11": ["03", "15", "28", "40", "53"], "12": ["05", "18", "30", "43", "55"], "19": ["01", "18", "35", "51"], "14": ["01", "18", "35", "51"], "06": ["07", "24", "40", "53"], "22": ["05", "24", "48"], "20": ["08", "25", "41", "58"]], extras: "CRVENO - NISKOPODNI, ZELENO PODVUČENO - NISKOPODNI SA RAMPOM")
        XCTAssertNotEqual(bus,busNew)
    }
    
    func test_dayNotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil, day: "", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR")
        XCTAssertNotEqual(bus,busNew)
    }
    func test_scheduleANotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil,day: "S", scheduleA: ["13": ["05"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR")
        XCTAssertNotEqual(bus,busNew)
    }
    func test_scheduleBNotEqual() {
        let json = """
        {
            "id": "52",
            "broj": "52",
            "naziv": "VETERNIK",
            "linijaA": "Polasci za  VETERNIK",
            "linijaB": "Polasci iz  VETERNIK",
            "dan": "S",
            "rasporedA": {
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
            },
            "rasporedB": {
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
            },
            "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil, day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"]], schedule: nil, extras: "IL=IZ LIRA, LIR=ZA LIR")
        XCTAssertNotEqual(bus,busNew)
    }
    
    func test_scheduleNotEqual() {
           let json = """
           {
               "id": "7A.",
               "broj": "7A",
               "naziv": "N.NASELJE-Z.STAN-F.PIJA-LIMAN4-N.NASELJE",
               "linija": "N.NASELJE - Z.STAN - F.PIJA - LIMAN4 - N.NASELJE",
               "dan": "S",
               "raspored": {
                   "10": [
                       "00",
                       "13",
                       "25",
                       "38",
                       "50"
                   ],
                   "11": [
                       "03",
                       "15",
                       "28",
                       "40",
                       "53"
                   ],
                   "12": [
                       "05",
                       "18",
                       "30",
                       "43",
                       "55"
                   ],
                   "13": [
                       "11",
                       "28",
                       "45"
                   ],
                   "14": [
                       "01",
                       "18",
                       "35",
                       "51"
                   ],
                   "15": [
                       "08",
                       "25",
                       "41",
                       "58"
                   ],
                   "16": [
                       "15",
                       "31",
                       "48"
                   ],
                   "17": [
                       "05",
                       "21",
                       "38",
                       "55"
                   ],
                   "18": [
                       "11",
                       "28",
                       "45"
                   ],
                   "19": [
                       "01",
                       "18",
                       "35",
                       "51"
                   ],
                   "20": [
                       "08",
                       "25",
                       "41",
                       "58"
                   ],
                   "21": [
                       "15",
                       "31",
                       "48"
                   ],
                   "22": [
                       "05",
                       "24",
                       "48"
                   ],
                   "23": [
                       "12",
                       "36"
                   ],
                   "04": [
                       "30"
                   ],
                   "05": [
                       "00",
                       "25",
                       "50"
                   ],
                   "06": [
                       "07",
                       "24",
                       "40",
                       "53"
                   ],
                   "07": [
                       "05",
                       "18",
                       "30",
                       "43",
                       "55"
                   ],
                   "08": [
                       "08",
                       "20",
                       "33",
                       "45",
                       "58"
                   ],
                   "09": [
                       "10",
                       "23",
                       "35",
                       "48"
                   ],
                   "00": [
                       "00"
                   ]
               },
               "dodaci": "CRVENO - NISKOPODNI, ZELENO PODVUČENO - NISKOPODNI SA RAMPOM"
           }
           """.data(using: .utf8)!
           let decoder = JSONDecoder()
           let bus = try! decoder.decode(Bus.self, from: json)
        let busNew = Bus(id: "7A.", number: "7A", name: "N.NASELJE-Z.STAN-F.PIJA-LIMAN4-N.NASELJE", lineA: nil, lineB: nil, line: "N.NASELJE - Z.STAN - F.PIJA - LIMAN4 - N.NASELJE", day: "S",scheduleA: nil, scheduleB: nil, schedule: ["16": ["15", "31", "48"]], extras: "CRVENO - NISKOPODNI, ZELENO PODVUČENO - NISKOPODNI SA RAMPOM")
           XCTAssertNotEqual(bus,busNew)
       }
    func test_extrasNotEqual() {
         let json = """
         {
             "id": "52",
             "broj": "52",
             "naziv": "VETERNIK",
             "linijaA": "Polasci za  VETERNIK",
             "linijaB": "Polasci iz  VETERNIK",
             "dan": "S",
             "rasporedA": {
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
             },
             "rasporedB": {
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
             },
             "dodaci": "IL=IZ LIRA, LIR=ZA LIR"
         }
         """.data(using: .utf8)!
         let decoder = JSONDecoder()
         let bus = try! decoder.decode( Bus.self, from: json)
        let busNew =  Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil, day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "")
         XCTAssertNotEqual(bus,busNew)
     }
    
    func test_getScheduleAByHour(){
        let bus = Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil, day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "")
        let array = bus.getScheduleAByHour()
        let expectedResult = ["05: 30 ","06: 35 ","09: 00 ","11: 00 ","13: 05 ", "14: 10 ", "15: 15 ", "16: 20 ","17: 25 ","18: 30 ", "19: 35 ", "23: 40 ",]
        XCTAssertEqual(array, expectedResult)
    }
    func test_getScheduleBByHour(){
        let bus = Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil, day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "")
        let array = bus.getScheduleBByHour()
        let expectedResult = ["04: 55 " ,"06: 00 ","07: 05 ","09: 30 ","11: 30 ","13: 35 ","14: 40 ","15: 45 ","16: 50 ","17: 55 ","19: 00 ", "20: 05 "]
        XCTAssertEqual(array, expectedResult)
    }
    func test_getOneWayScheduleByHour(){
        let bus = Bus(id: "7A.", number: "7A", name: "N.NASELJE-Z.STAN-F.PIJA-LIMAN4-N.NASELJE", lineA: nil, lineB: nil, line: "N.NASELJE - Z.STAN - F.PIJA - LIMAN4 - N.NASELJE", day: "S", scheduleA: nil, scheduleB: nil, schedule: ["16": ["15", "31", "48"], "13": ["11", "28", "45"], "07": ["05", "18", "30", "43", "55"], "10": ["00", "13", "25", "38", "50"], "15": ["08", "25", "41", "58"], "00": ["00"], "09": ["10", "23", "35", "48"], "23": ["12", "36"], "18": ["11", "28", "45"], "17": ["05", "21", "38", "55"], "05": ["00", "25", "50"], "08": ["08", "20", "33", "45", "58"], "21": ["15", "31", "48"], "04": ["30"], "11": ["03", "15", "28", "40", "53"], "12": ["05", "18", "30", "43", "55"], "19": ["01", "18", "35", "51"], "14": ["01", "18", "35", "51"], "06": ["07", "24", "40", "53"], "22": ["05", "24", "48"], "20": ["08", "25", "41", "58"]], extras: "CRVENO - NISKOPODNI, ZELENO PODVUČENO - NISKOPODNI SA RAMPOM")
        let array = bus.getOneWayScheduleByHour()
        let expectedResult = ["00: 00 ", "04: 30 ", "05: 00 25 50 ", "06: 07 24 40 53 ", "07: 05 18 30 43 55 ", "08: 08 20 33 45 58 ", "09: 10 23 35 48 ", "10: 00 13 25 38 50 ", "11: 03 15 28 40 53 ", "12: 05 18 30 43 55 ", "13: 11 28 45 ", "14: 01 18 35 51 ", "15: 08 25 41 58 ", "16: 15 31 48 ", "17: 05 21 38 55 ", "18: 11 28 45 ", "19: 01 18 35 51 ", "20: 08 25 41 58 ", "21: 15 31 48 ", "22: 05 24 48 ", "23: 12 36 "]
        XCTAssertEqual(array, expectedResult)
    }
    func test_getScheduleABy3Hours(){
        let bus = Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil, day: "S", scheduleA: ["00":[], "01":[], "02":[], "03":[], "04":[], "05":[], "06":[], "07":[], "08":[], "09":[],"10":[], "11": [], "12": [] ,"13":[], "14": [], "15": [] ,"16":[], "17": [], "18": [] ,"19":[], "20": [], "21": [] , "22": [], "23": [] ], scheduleB: ["19": ["00"], "16": ["50"], "20": ["05"], "13": ["35"], "09": ["30"], "11": ["30"], "17": ["55"], "14": ["40"], "07": ["05"], "06": ["00"], "04": ["55"], "15": ["45"]], schedule: nil, extras: "")
        let array = bus.getScheduleABy3Hours()
        let expectedResult = ["\(Int(DateManager.instance.getHour())! - 1): ","\(Int(DateManager.instance.getHour())!): ","\(Int(DateManager.instance.getHour())! + 1): "]
        XCTAssertEqual(array, expectedResult)
    }
    func test_getScheduleBBy3Hours(){
        let bus = Bus(id: "52", number: "52", name: "VETERNIK", lineA: "Polasci za  VETERNIK", lineB: "Polasci iz  VETERNIK", line: nil, day: "S", scheduleA: ["13": ["05"], "23": ["40"], "11": ["00"], "16": ["20"], "15": ["15"], "19": ["35"], "06": ["35"], "18": ["30"], "05": ["30"], "14": ["10"], "17": ["25"], "09": ["00"]], scheduleB: ["00":[], "01":[], "02":[], "03":[], "04":[], "05":[], "06":[], "07":[], "08":[], "09":[],"10":[], "11": [], "12": [] ,"13":[], "14": [], "15": [] ,"16":[], "17": [], "18": [] ,"19":[], "20": [], "21": [] , "22": [], "23": [] ], schedule: nil, extras: "")
        let array = bus.getScheduleBBy3Hours()
        let expectedResult = ["\(Int(DateManager.instance.getHour())! - 1): ","\(Int(DateManager.instance.getHour())!): ","\(Int(DateManager.instance.getHour())! + 1): "]
        XCTAssertEqual(array, expectedResult)
    }
    func test_getOneWayScheduleBy3Hours(){
        let bus = Bus(id: "7A.", number: "7A", name: "N.NASELJE-Z.STAN-F.PIJA-LIMAN4-N.NASELJE", lineA: nil, lineB: nil, line: "N.NASELJE - Z.STAN - F.PIJA - LIMAN4 - N.NASELJE", day: "S", scheduleA: nil, scheduleB: nil, schedule: ["00":[], "01":[], "02":[], "03":[], "04":[], "05":[], "06":[], "07":[], "08":[], "09":[],"10":[], "11": [], "12": [] ,"13":[], "14": [], "15": [] ,"16":[], "17": [], "18": [] ,"19":[], "20": [], "21": [] , "22": [], "23": [] ], extras: "CRVENO - NISKOPODNI, ZELENO PODVUČENO - NISKOPODNI SA RAMPOM")
        let array = bus.getOneWayScheduleBy3Hours()
        let expectedResult = ["\(Int(DateManager.instance.getHour())! - 1): ","\(Int(DateManager.instance.getHour())!): ","\(Int(DateManager.instance.getHour())! + 1): "]
        XCTAssertEqual(array, expectedResult)
    }
}
