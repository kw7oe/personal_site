//
//  TestHelper.swift
//  Progressus
//
//  Created by Choong Kai Wern on 10/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import XCTest
import CoreData
@testable import Progressus

class TestHelper: XCTestCase {
    
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

func addAndReturnChallenge(unique: String, context: NSManagedObjectContext) -> CDChallenge {
    let created = CDChallenge.createChallenge((unique, 7, Date.init(date: "2017-7-17"), true), inContext: context)
    XCTAssert(created)
    
    return CDChallenge.findChallenge(inContext: context, unique: unique)!
}
