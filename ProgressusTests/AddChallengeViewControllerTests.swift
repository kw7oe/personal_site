//
//  AddChallengeViewControllerTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 05/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
import CoreData
@testable import Progressus

class AddChallengeViewControllerTests: XCTestCase {
    
    var controller: AddChallengeTableViewController!
    var context: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        controller = storyboard.instantiateViewController(withIdentifier: "AddChallengeTableViewController") as! AddChallengeTableViewController
        controller.context = context
        
        XCTAssertNotNil(controller.view)
    }
    
    override func tearDown() {
        context = nil
        super.tearDown()
    }
    
    func testGoalRange() {
        XCTAssertNotNil(controller.goalRange)
    }
    
    func testUpdateCount() {
        controller.nameTextField.text = "Apple"
        controller.textFieldEditingChanged(controller.nameTextField)
        XCTAssertEqual(controller.textCountLabel.text, "5/20")
    }
    
    func testModeShouldBeAdd() {
        XCTAssertEqual(controller.mode, .add)
    }
    
    func testSaveChallenge() {
        saveChallenge()
        
        let challenges = CDChallenge.all(inContext: context!)
        XCTAssertEqual(challenges.count, 1)
        let challenge = challenges[0]
        
        XCTAssertEqual(challenge.unique, "Workout")
        XCTAssertEqual(challenge.goal, 7)
        XCTAssert(challenge.started)
    }
    
    func testSaveChallengeWithDuplicateName() {
        saveChallenge()
        
        controller.nameTextField.text = "Workout"
        controller.saveChallenge(UIBarButtonItem.init())
        
        let challenges = CDChallenge.all(inContext: context!)
        XCTAssertEqual(challenges.count, 1)
    }
    
    func testShouldStripeWhiteSpaceForChallengeName() {
        saveChallenge("Workout ")
        saveChallenge("Read Books")
        
        let challenges = CDChallenge.all(inContext: context!)
        XCTAssertEqual(challenges[1].unique, "Workout")
        XCTAssertEqual(challenges[0].unique, "Read Books")
    }
    
    func saveChallenge(_ text: String = "Workout") {
        controller.nameTextField.text = text
        controller.goalPicker.selectRow(6, inComponent: 0, animated: false)
        controller.saveChallenge(UIBarButtonItem.init())
        
        XCTAssertNotNil(CDChallenge.all(inContext: context!))
    }
    
}
