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
    
    func testAllShouldBeEmpty() {
        let context = setUpInMemoryManagedObjectContext()
        let challenges = CDChallenge.all(inContext: context)
        
        XCTAssertNotNil(challenges)
        XCTAssert(challenges!.isEmpty)
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
            
            XCTAssertNotNil(challenges)
            XCTAssertEqual(challenges!.count, 1)
            XCTAssertEqual(challenges![0], returnChallenge)
        } catch {
            print(error)
        }
    }
    
    func testCount() {
        let context = setUpInMemoryManagedObjectContext()
        XCTAssertEqual(CDChallenge.count(inContext: context), 0)
    }
    
    func testUpdateChallenge() {
        let context = setUpInMemoryManagedObjectContext()
        addChallenge(inContext: context)
        
        let date = Date.init()
        
        let attr: [String:Any] = [
            "name": "Reading",
            "goal": 15,
            "date": date,
            "started": false
        ]
        
        let result = CDChallenge.updateChallenge(inContext: context, unique: challenge.name, with: attr)
        
        let updatedChallenge = CDChallenge.findChallenge(inContext: context, unique: "Reading")
        
        XCTAssert(result)
        
        let challenges = CDChallenge.all(inContext: context)
        XCTAssertNotNil(challenges)
        XCTAssertEqual(challenges!.count, 1)
        
        XCTAssertNotNil(updatedChallenge)
        XCTAssertEqual(updatedChallenge!.goal, 15)
        XCTAssertEqual(updatedChallenge!.unique, "Reading")
        XCTAssertEqual(updatedChallenge!.started, false)
        XCTAssertEqual(updatedChallenge!.date, date as NSDate)
        
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

func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])
    let persistantStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
    
    do {
        try persistantStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }
    
    let managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistantStoreCoordinator
    
    return managedObjectContext
}
