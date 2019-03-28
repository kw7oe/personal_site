//
//  EditChallengeViewControllerTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 10/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
import CoreData
@testable import Progressus

class EditChallengeViewControllerTests: XCTestCase {
    
    var controller: AddChallengeTableViewController!
    var context: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        controller = storyboard.instantiateViewController(withIdentifier: "AddChallengeTableViewController") as? AddChallengeTableViewController
        
        context = setUpInMemoryManagedObjectContext()
        let challenge = addAndReturnChallenge(unique: "Workout", context: context!)
        controller.context = context
        controller.challenge = challenge
        
        XCTAssertNotNil(controller.view)
    }
    
    override func tearDown() {
        context = nil
        super.tearDown()
    }
    
    func testModeShouldBeEdit() {
        XCTAssertEqual(controller.mode, .edit)
    }
    
    func testEditChallenge() {
        let date = Date.init(date: "2017-6-17")
        
        controller.nameTextField.text = "Reading"
        controller.goalPicker.selectRow(12, inComponent: 0, animated: false)
        controller.startDatePicker.setDate(date, animated: false)
        controller.saveChallenge(UIBarButtonItem.init())
        
        let challenge = CDChallenge.all(inContext: context!)[0]
        XCTAssertEqual(challenge.unique, "Reading")
        XCTAssertEqual(challenge.goal, 13)
        XCTAssertEqual(challenge.date, date)
    }
    
}
