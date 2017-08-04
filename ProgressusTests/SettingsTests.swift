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
    
    func testUpdateChallenge() {
        addChallenge()
        
        let newChallenge = Challenge(name: "Read", date: Date.init(), goal: 10, started: true)
        Settings.updateChallenge(at: 0, with: newChallenge)
        
        XCTAssertNotNil(Settings.challenges)
        
        if let challenges = Settings.challenges {
            XCTAssertEqual(challenges[0].name, newChallenge.name)
            XCTAssertEqual(challenges[0].goal, newChallenge.goal)
        }
    }
    
    func testRemoveChallenge() {
        addChallenge()
        
        Settings.removeChallenge(at: 1)
        XCTAssertEqual(Settings.challenges!.count, 1)
        XCTAssertEqual(Settings.challenges!.first!.name, challenge2.name)
    }
    
    func testStartOnResetShouldBeFalseInitially() {
        XCTAssertFalse(Settings.startOnReset)
    }
    
    func testStartOnResetToTrue() {
        Settings.startOnReset = true
        XCTAssert(Settings.startOnReset)
    }
    
    func testThemeShouldBeLightInitially() {
        XCTAssertEqual(Settings.theme, .light)
    }
    
    func testThemeShouldBeLightIfInvalidTheme() {
        Settings.settings.set("123", forKey: Settings.Key.Theme)
        XCTAssertEqual(Settings.theme, .light)
    }
    
    func testThemeToDark() {
        Settings.theme = .dark
        XCTAssertEqual(Settings.theme, .dark)
    }
    
    func testColorIndexShouldBeZeroInitially() {
        XCTAssertEqual(Settings.colorIndex, 0)
    }
    
    func testColorIndexSetToSix() {
        Settings.colorIndex = 6
        XCTAssertEqual(Settings.colorIndex, 6)
    }
    
    func addChallenge() {
        Settings.prependChallenge(with: challenge)
        Settings.prependChallenge(with: challenge2)
        XCTAssertEqual(Settings.challenges!.count, 2)
    }

}
