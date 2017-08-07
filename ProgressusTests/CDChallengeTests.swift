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
    
    func testDeleteChallenge() {
        let context = setUpInMemoryManagedObjectContext()
        do {
            _ = try CDChallenge.findOrCreateChallenge(challenge, inContext: context)
        } catch {
            print(error)
        }
        
        let result = CDChallenge.deleteChallenge(inContext: context, unique: "Workout")
        
        XCTAssert(result)
        XCTAssertEqual(CDChallenge.count(inContext: context), 0)
        
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
