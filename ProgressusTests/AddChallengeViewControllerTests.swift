//
//  AddChallengeViewControllerTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 05/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus

class AddChallengeViewControllerTests: XCTestCase {
    
    var controller: AddChallengeTableViewController!
    
    override func setUp() {
        super.setUp()
        
        ChallengeFactory.userDefaults = UserDefaults(suiteName: "Testing")!
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        controller = storyboard.instantiateViewController(withIdentifier: "AddChallengeTableViewController") as! AddChallengeTableViewController
        
        XCTAssertNotNil(controller.view)
    }
    
    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: "Testing")
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
    
    func testSaveChallenge() {
        saveChallenge()
        
        if let challenges = ChallengeFactory.challenges {
            XCTAssertEqual(challenges.count, 1)
            let challenge = challenges[0]
            
            XCTAssertEqual(challenge.name, "Workout")
            XCTAssertEqual(challenge.goal, 7)
            XCTAssert(challenge.started)
        }
    }
    
    func testSaveChallengeWithDuplicateName() {
        saveChallenge()
        
        controller.nameTextField.text = "Workout"
        controller.saveChallenge(UIBarButtonItem.init())
        
        XCTAssertEqual(ChallengeFactory.challenges?.count, 1)
    }
    
    func testShouldStripeWhiteSpaceForChallengeName() {
        saveChallenge("Workout ")
        
        XCTAssertEqual(ChallengeFactory.challenges![0].name, "Workout")
        
        saveChallenge("Read Books")
        XCTAssertEqual(ChallengeFactory.challenges![0].name, "Read Books")
    }
    
    func saveChallenge(_ text: String = "Workout") {
        controller.nameTextField.text = text
        controller.goalPicker.selectRow(6, inComponent: 0, animated: false)
        controller.saveChallenge(UIBarButtonItem.init())
        
        XCTAssertNotNil(ChallengeFactory.challenges)
    }
    
}
