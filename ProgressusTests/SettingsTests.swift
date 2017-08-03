//
//  SettingsTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 03/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus

class SettingsTests: XCTestCase {
    
    var userDefault = UserDefaults(suiteName: "TestingSettings")
    let challenge = Challenge(name: "Workout", date: Date.init(), goal: 10, started: true)
    let challenge2 = Challenge(name: "Read", date: Date.init(), goal: 7, started: true)
    
    override func setUp() {
        Settings.settings = userDefault!
    }

    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: "TestingSettings")
    }
    
    func testSettingsReminderCount() {
        XCTAssertEqual(Settings.reminderCounts, 3)
    }
    
    func testChallengesShouldBeNilInitially() {
        XCTAssertNil(Settings.challenges)
    }
    
    func testPrependChallenge() {
        Settings.prependChallenge(with: challenge)
        
        XCTAssertNotNil(Settings.challenges)
        
        if let challenges = Settings.challenges {
            XCTAssertEqual(challenges.count, 1)
            XCTAssertEqual(challenges.first!.name, challenge.name)
        }
        
        Settings.prependChallenge(with: challenge2)
        XCTAssertEqual(Settings.challenges!.count, 2)
        XCTAssertEqual(Settings.challenges!.first!.name, challenge2.name)
    }
    
    func testRemoveChallenge() {
        Settings.prependChallenge(with: challenge)
        Settings.prependChallenge(with: challenge2)
        XCTAssertEqual(Settings.challenges!.count, 2)
        
        
        Settings.removeChallenge(at: 1)
        XCTAssertEqual(Settings.challenges!.count, 1)
        XCTAssertEqual(Settings.challenges!.first!.name, challenge2.name)
    }

    
}
