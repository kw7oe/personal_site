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

}
