//
//  ChallengeTableViewControllerTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 10/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
import CoreData
@testable import Progressus

class ChallengeTableViewControllerTests: XCTestCase {
    
    var controller: ChallengesTableViewController!
    var context: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        controller = storyboard.instantiateViewController(withIdentifier: "ChallengesTableViewController") as! ChallengesTableViewController
        controller.context = context!
        
        XCTAssertNotNil(controller.view)
        XCTAssertNotNil(controller.tableView)
    }
    
    override func tearDown() {
        context = nil
        super.tearDown()
    }
    
    func testBlankViewShouldAppearIfChallengesIsBlank() {
        XCTAssert(controller.challenges.isEmpty)
        XCTAssertEqual(controller.numberOfSections(in: controller.tableView), 0)
        XCTAssertNotNil(controller.tableView.backgroundView)
        XCTAssertEqual(controller.tableView.backgroundView!.frame, controller.blankView.frame)
    }
    
    func testNumberOfSectionEqualsToChallengesCount() {
        _ = addAndReturnChallenge(unique: "Workout", context: context!)
        _ = addAndReturnChallenge(unique: "Read", context: context!)
        
        XCTAssertEqual(controller.challenges.count, 2)
        
        let sec = controller.numberOfSections(in: controller.tableView)
        XCTAssertEqual(sec, controller.challenges.count)
    }
    
    
}
