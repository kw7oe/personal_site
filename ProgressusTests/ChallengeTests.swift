//
//  ChallengeTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 03/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus

class ChallengeTests: XCTestCase {
    
    var date = Date.init(date: "2017-7-18")
    let timeInterval = -(7.0 * 24 * 3600 + 5.0 * 3600) // 7 days 5 hours ago == 173 hours ago
    let timeIntervalInHour: Float = 173.0
    var challenge = Challenge.init(name: "Workout", date: Date.init(date: "2017-7-18"), goal: 10, started: false)
    
    func testGetter() {
        XCTAssertEqual(challenge.goal, 10)
        XCTAssertEqual(challenge.name, "Workout")
        XCTAssertEqual(challenge.date, date)
        XCTAssertEqual(challenge.started, false)
    }
    
    func testSetDateShouldChangeStartedToTrue() {
        XCTAssertFalse(challenge.started)
        challenge.set_date(date)
        XCTAssert(challenge.started)
    }
    
    func testTime() {
        // Challenge not started
        XCTAssertEqual(challenge.time, 0)
        // Start Challenge
        challenge.set_date(date)
        XCTAssertEqual(challenge.time, -Int(date.timeIntervalSinceNow))
    }
    
    func testProgressPercentage() {
        challenge.set_date(Date.init(timeIntervalSinceNow: timeInterval))
        let percentage = timeIntervalInHour / Float(challenge.goal * 24)
        XCTAssertEqual(challenge.progressPercentage, percentage)
    }
    
    func testProgressPercentageString() {
        XCTAssertEqual(challenge.progressPercentageString, "0.0") // Challenge Not Started
        challenge.set_date(date) // Start Challenge
        XCTAssertEqual(challenge.progressPercentageString, "100")
    }
    
    func testProgressPercentageStringUsingProgressPercentage() {
        challenge.set_date(Date.init(timeIntervalSinceNow: timeInterval))
        let percentage = challenge.progressPercentage
        let percentageText = String.init(format: "%.1f", percentage * 100)
        XCTAssertEqual(challenge.progressPercentageString, percentageText)
    }
    
    func testProgressDescription() {
        let result = "7  days  5  hours  "
        challenge.set_date(Date.init(timeIntervalSinceNow: timeInterval))
        XCTAssertEqual(challenge.progressDescription, result)
    
    }

}
