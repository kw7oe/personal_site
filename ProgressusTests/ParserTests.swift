//
//  ParserTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 19/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus

class ParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseDate() {
        let date = Date.init(date: "2017-1-17")
        XCTAssertEqual("Jan 17, 2017", Parser.parse(date: date))
    }
    
    func testParseTime() {
        let time = Date.init(time: "7:29")
        XCTAssertEqual("7:29 AM", Parser.parse(time: time))
    }
    
    func testParseTimePM() {
        let time = Date.init(time: "14:30")
        XCTAssertEqual("2:30 PM", Parser.parse(time: time))
    }
    
    func testParse() {
        let testInput = Parser.parse(time: 7, basedOn: .day)
        XCTAssert(testInput == (time: "7", unit: "  days  "))
    }
}

extension Date {
    
    init(date: String) {
        let component = date.characters.split(separator: "-").map { (c) -> Int? in
            Int.init(String.init(c))
        }
        var dateComponent = DateComponents()
        dateComponent.year = component[0]
        dateComponent.month = component[1]
        dateComponent.day = component[2]
        dateComponent.calendar = Calendar.current
        self = dateComponent.date!
    }
    
    init(time: String) {
        let component = time.characters.split(separator: ":").map { (c) -> Int? in
            Int.init(String.init(c))
        }
        var dateComponent = DateComponents()
        dateComponent.hour = component[0]
        dateComponent.minute = component[1]
        dateComponent.calendar = Calendar.current
        self = dateComponent.date!
        
    }
}
