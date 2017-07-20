//
//  ProgressusUITests.swift
//  ProgressusUITests
//
//  Created by Choong Kai Wern on 20/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest

class ProgressusUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testAddChallenge() {
        let app = XCUIApplication()
        let count = app.tables.cells.count + 1
        app.navigationBars["Progressus"].buttons["Add"].tap()
        
        let challengeNameSearchField = app.tables.searchFields["Challenge Name"]
        challengeNameSearchField.tap()
        challengeNameSearchField.typeText("Foobar")
        
        app.navigationBars["Progressus.AddChallengeTableView"].buttons["Save"].tap()
        
        XCTAssertEqual(app.tables.cells.count, count)
        
        let cellLabel = app.tables.cells.element(boundBy: 0).staticTexts.element(boundBy: 1)
        XCTAssertEqual(cellLabel.label, "Foobar")
    }
    
    func testRemoveChallenge() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let cell = tablesQuery.cells.element(boundBy: 0)
        let count = app.tables.cells.count - 1
        cell.swipeLeft()
        cell.buttons["Delete"].tap()
        
        XCTAssertEqual(app.tables.cells.count, count)
    }
    
    func testGoToSetting() {        
        let app = XCUIApplication()
        app.navigationBars["Progressus"].buttons["Settings"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 4)
        cell.children(matching: .button).element(boundBy: 1).tap()
        cell.children(matching: .button).element(boundBy: 6).tap()
        cell.children(matching: .button).element(boundBy: 5).tap()
        cell.children(matching: .button).element(boundBy: 4).tap()
        
        
        tablesQuery.switches["Dark Theme"].tap()
    }
    
}
