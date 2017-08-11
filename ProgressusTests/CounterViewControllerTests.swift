//
//  CounterViewControllerTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 11/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
import CoreData
@testable import Progressus

class CounterViewControllerTests: XCTestCase {
    
    var controller: CounterViewController!
    var context: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        context = setUpInMemoryManagedObjectContext()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        controller = storyboard.instantiateViewController(withIdentifier: "CounterViewController") as! CounterViewController
        
        let challenge = addAndReturnChallenge(unique: "Workout", context: context!)
        controller.context = context!
        controller.challenge = challenge
        
        XCTAssertNotNil(controller.view)
    }
    
    override func tearDown() {
        context = nil
        super.tearDown()
    }
    
    func testTimer() {
        controller.viewWillAppear(false)
        XCTAssert(controller.timer.isValid)
        XCTAssertEqual(controller.timer.timeInterval, 1)
        
        controller.viewWillDisappear(false)
        XCTAssertFalse(controller.timer.isValid)
    }
    
    func testDescriptionLabel() {
        let expected = controller.challenge.progressDescription
        XCTAssertEqual(controller.descriptionLabel.text, expected)
    }
    
    func testTimeLabel() {
        XCTAssertEqual(controller.timeLabel.text, String(controller.challenge.time))
    }
    
    func testTimeUnitLabel() {
        XCTAssertEqual(controller.timeUnitLabel.text, "seconds")
    }
    
    func testTimeWillUpdate() {
        controller.viewWillAppear(false)
        
        let text = controller.timeLabel.text
        
        // Wait 1 seconds
        RunLoop.main.run(until: Date.init(timeIntervalSinceNow: 1))
        
        let text2 = controller.timeLabel.text
        
        XCTAssertNotEqual(text, text2)
    }
    
    func testProgressPieView() {
        controller.viewWillAppear(false)
        XCTAssertEqual(controller.progressView.label.text, "100\npercent")
    }
    
    func testButton() {
        controller.viewWillAppear(false)
        XCTAssertEqual(controller.button.titleLabel?.text, "RESET")
    }
    
}
