//
//  ProgressusUITests.swift
//  ProgressusUITests
//
//  Created by Choong Kai Wern on 20/07/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest

class ProgressusUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        app.launchArguments += ["UI-Testing"]
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testAddChallenge() {
        let count = app.tables.cells.count + 1
        
        addChallenge(name: "Foo")
        
        XCTAssertEqual(app.tables.cells.count, count)
        
        let cellLabel = app.tables.cells.element(boundBy: 0).staticTexts.element(boundBy: 1)
        XCTAssertEqual(cellLabel.label, "Foo")
    }
    
    func testAddChallengeWithDuplicateName() {
        addChallenge(name: "Workout")
        
        XCTAssertEqual(app.alerts.count,  1)
        app.alerts["Duplicated name"].buttons["OK"].tap()
        XCTAssertEqual(app.alerts.count, 0)
        
        let count = app.tables.cells.count
        
        XCTAssertEqual(app.tables.cells.count, count)
    }
    
    func testRemoveChallenge() {
        let tablesQuery = app.tables
        let cell = tablesQuery.cells.element(boundBy: 0)
        let count = app.tables.cells.count - 1
        cell.swipeLeft()
        cell.buttons["Delete"].tap()
        
        XCTAssertEqual(app.tables.cells.count, count)
    }
    
    func testTapChallengeCell() {
        app.tables.cells.element(boundBy: 0).tap()
        
        app.buttons["RESET"].tap()
        app.alerts["Reset Challenge"].buttons["YES"].tap()
        
        XCTAssertNotNil(app.buttons["START"])
        
        let moreButton = app.navigationBars["Progressus.CounterView"].children(matching: .button).element(boundBy: 1)
        moreButton.tap()
        
        let sheetsQuery = app.sheets
        sheetsQuery.buttons["Edit"].tap()
        app.navigationBars["Progressus.AddChallengeTableView"].buttons["Cancel"].tap()
        
        moreButton.tap()
        sheetsQuery.buttons["Delete Challege"].tap()
        app.alerts["Delete Challenge"].buttons["YES"].tap()
        
    }
    
    func addChallenge(name: String) {
        let count = app.tables.cells.count
        
        if count < 4 {
            app.navigationBars["Progressus"].buttons["Add"].tap()
            
            let challengeNameSearchField = app.tables.searchFields["Challenge Name"]
            challengeNameSearchField.tap()
            challengeNameSearchField.typeText(name)
            
            app.navigationBars["Progressus.AddChallengeTableView"].buttons["Save"].tap()
        }
    }
    
    func testGoToSetting() {
        XCUIApplication().navigationBars["Progressus"].children(matching: .button).element(boundBy: 1).tap()
    
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 4)
        cell.children(matching: .button).element(boundBy: 1).tap()
        cell.children(matching: .button).element(boundBy: 6).tap()
        cell.children(matching: .button).element(boundBy: 5).tap()
        cell.children(matching: .button).element(boundBy: 4).tap()
        
        tablesQuery.switches["Dark Theme"].tap()
    }
    
}
