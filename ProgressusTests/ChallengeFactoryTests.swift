//
//  ChallengeFactoryTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 04/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus

class ChallengeFactoryTests: XCTestCase {
    
    var userDefault = UserDefaults(suiteName: "TestingChallengeFactory")
    let challenge = Challenge(name: "Workout", date: Date.init(), goal: 10, started: true)
    let challenge2 = Challenge(name: "Read", date: Date.init(), goal: 7, started: true)
    
    override func setUp() {
        ChallengeFactory.userDefaults = userDefault!
    }
    
    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: "TestingChallengeFactory")
    }
    
    func testChallengesShouldBeNilInitially() {
        XCTAssertNil(ChallengeFactory.challenges)
    }
    
    func testPrependChallenge() {
        ChallengeFactory.prependChallenge(with: challenge)
        
        XCTAssertNotNil(ChallengeFactory.challenges)
        
        if let challenges = ChallengeFactory.challenges {
            XCTAssertEqual(challenges.count, 1)
            XCTAssertEqual(challenges.first!.name, challenge.name)
        }
        
        ChallengeFactory.prependChallenge(with: challenge2)
        XCTAssertEqual(ChallengeFactory.challenges!.count, 2)
        XCTAssertEqual(ChallengeFactory.challenges!.first!.name, challenge2.name)
    }
    
    func testUpdateChallenge() {
        addChallenge()
        
        let newChallenge = Challenge(name: "Read", date: Date.init(), goal: 10, started: true)
        ChallengeFactory.updateChallenge(at: 0, with: newChallenge)
        
        XCTAssertNotNil(ChallengeFactory.challenges)
        
        if let challenges = ChallengeFactory.challenges {
            XCTAssertEqual(challenges[0].name, newChallenge.name)
            XCTAssertEqual(challenges[0].goal, newChallenge.goal)
        }
    }
    
    func testRemoveChallenge() {
        addChallenge()
        
        ChallengeFactory.removeChallenge(at: 1)
        XCTAssertEqual(ChallengeFactory.challenges!.count, 1)
        XCTAssertEqual(ChallengeFactory.challenges!.first!.name, challenge2.name)
    }
    
    func addChallenge() {
        ChallengeFactory.prependChallenge(with: challenge)
        ChallengeFactory.prependChallenge(with: challenge2)
        XCTAssertEqual(ChallengeFactory.challenges!.count, 2)
    }

    
}
