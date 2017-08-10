//
//  DataMigrationTests.swift
//  Progressus
//
//  Created by Choong Kai Wern on 08/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
@testable import Progressus

class DataMigrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        DataMigration.userDefaults =  UserDefaults(suiteName: "Testing")!
        ChallengeFactory.userDefaults = UserDefaults(suiteName: "Testing")!
    }
    
    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: "Testing")
        super.tearDown()
    }
    
    func testMigrateData() {
        setupPreviousData()
        XCTAssertFalse(DataMigration.migrated)
        DataMigration.migrateData()
        XCTAssert(DataMigration.migrated)
        
        XCTAssertNotNil(ChallengeFactory.challenges)
        XCTAssertEqual(ChallengeFactory.challenges![0].goal, 7)
    }
    
    func testMigrateToCoreData() {
        let context = setUpInMemoryManagedObjectContext()
        
        XCTAssertFalse(DataMigration.migratedToCoreData)
        setupPreviousChallengeData()
        DataMigration.migrateToCoreData(inContext: context)        
        
        let challenges = CDChallenge.all(inContext: context)
            
        XCTAssertEqual(challenges.count, 1)
        XCTAssertEqual(challenges[0].unique!, "Workout")
        
        XCTAssert(DataMigration.migratedToCoreData)
    }
    
    func setupPreviousChallengeData() {
        let challenge = Challenge.init(name: "Workout", date: Date.init(), goal: 7, started: true)
        _ = ChallengeFactory.prependChallenge(with: challenge)
        XCTAssertEqual(ChallengeFactory.challenges!.count, 1)
    }
    
    func setupPreviousData() {
        DataMigration.userDefaults.set(true, forKey: DataMigration.DeprecatedKey.DateStarted)
        DataMigration.userDefaults.set(7, forKey: DataMigration.DeprecatedKey.Goal)
        DataMigration.userDefaults.set(Date.init(), forKey: DataMigration.DeprecatedKey.Date)
    }
    
}
