//
//  ParserTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 19/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus

class DateConverterTest: XCTestCase {
    
    func testConvertTime() {
        let time = Date.init(time: "7:29")
        XCTAssertEqual("7:29 AM", DateConverter.convert(time: time))
    }
    
    func testConvertTimePM() {
        let time = Date.init(time: "14:30")
        XCTAssertEqual("2:30 PM", DateConverter.convert(time: time))
    }
    
    func testConvert() {
        let testInput = DateConverter.convert(time: 7, basedOn: .day)
        XCTAssert(testInput == (time: "7", unit: "  days  "))
    }
    
    func testConvertToArray() {
        let day = 1 * 24 * 60 * 60
        let eightHour = 8 * 60 * 60
        let testInput = DateConverter.convertToArray(time: day + eightHour, basedOn: .dayHour)
        XCTAssert(testInput[0] == (time: "1", unit: "  day  "))
        XCTAssert(testInput[1] == (time: "8", unit: "  hours  "))
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
