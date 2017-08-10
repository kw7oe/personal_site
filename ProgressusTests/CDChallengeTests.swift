//
//  CDChallengeTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 07/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
import CoreData
@testable import Progressus

class CDChallengeTests: XCTestCase {
    
    
    let challenge = Challenge.init(name: "Workout", date: Date.init(), goal: 7, started: true)
    let attr = ("Reading", 15, Date.init(date: "2017-7-17"), false)
    
    func testAllShouldBeEmpty() {
        let context = setUpInMemoryManagedObjectContext()
        let challenges = CDChallenge.all(inContext: context)
        
        XCTAssert(challenges.isEmpty)
    }
    
    func testFindChallenge() {
        let context = setUpInMemoryManagedObjectContext()
        addChallenge(inContext: context)
        
        let found = CDChallenge.findChallenge(inContext: context, unique: "Workout")
        XCTAssertNotNil(found)
        XCTAssertEqual(found!.unique, "Workout")
    }
    func testFindOrCreateChallenge() {
        let context = setUpInMemoryManagedObjectContext()
        do {
            let returnChallenge = try CDChallenge.findOrCreateChallenge(challenge, inContext: context)
            
            XCTAssertNotNil(returnChallenge)
            XCTAssertEqual(returnChallenge.unique!, challenge.name)
            
            let challenges = CDChallenge.all(inContext: context)
            
            XCTAssertEqual(challenges.count, 1)
            XCTAssertEqual(challenges[0], returnChallenge)
        } catch {
            print(error)
        }
    }
    
    func testCount() {
        let context = setUpInMemoryManagedObjectContext()
        XCTAssertEqual(CDChallenge.count(inContext: context), 0)
    }
    
    func testCastAttr() {
        
        let result = CDChallenge.castAttr(attr)
        
        XCTAssertEqual(result.unique, "Reading")
        XCTAssertEqual(result.goal, 15)
        XCTAssertEqual(result.date, Date.init(date: "2017-7-17") as NSDate)
        XCTAssertEqual(result.started, false)
    }
    
    func testUpdateChallenge() {
        let context = setUpInMemoryManagedObjectContext()
        addChallenge(inContext: context)
        
        let result = CDChallenge.updateChallenge(inContext: context, unique: challenge.name, with: attr)
        
        let updatedChallenge = CDChallenge.findChallenge(inContext: context, unique: "Reading")
        
        XCTAssert(result)
        
        let challenges = CDChallenge.all(inContext: context)
        XCTAssertNotNil(challenges)
        XCTAssertEqual(challenges.count, 1)
        
        XCTAssertNotNil(updatedChallenge)
        XCTAssertEqual(updatedChallenge!.goal, 15)
        XCTAssertEqual(updatedChallenge!.unique, "Reading")
        XCTAssertEqual(updatedChallenge!.started, false)
        XCTAssertEqual(updatedChallenge!.date, Date.init(date: "2017-7-17") as NSDate)
        
    }
    
    func testDeleteChallenge() {
        let context = setUpInMemoryManagedObjectContext()
        addChallenge(inContext: context)
        
        let result = CDChallenge.deleteChallenge(inContext: context, unique: "Workout")
        
        XCTAssert(result)
        XCTAssertEqual(CDChallenge.count(inContext: context), 0)
        
    }
    
    func addChallenge(inContext context: NSManagedObjectContext) {
        do {
            _ = try CDChallenge.findOrCreateChallenge(challenge, inContext: context)
        } catch {
            print(error)
        }
    }

    
}


