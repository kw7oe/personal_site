//
//  DataMigration.swift
//  Progressus
//
//  Created by Choong Kai Wern on 08/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation
import CoreData

class DataMigration {
    
    static var userDefaults = UserDefaults.standard
    
    struct Key {
        static let Migrated = "Migrated"
        static let MigratedCoreData = "MigratedCoreData"
    }
    
    struct DeprecatedKey {
        static let DateStarted = "Date Started"
        static let Goal = "Goal"
        static let Date = "Date"
    }
    
    static var migrated: Bool {
        get {
            return userDefaults.bool(forKey: Key.Migrated)
        }
        set {
            userDefaults.set(newValue, forKey: Key.Migrated)
        }
    }
    
    static func migrateData() {
        let started = userDefaults.bool(forKey: DeprecatedKey.DateStarted)
        guard let goal = userDefaults.object(forKey: DeprecatedKey.Goal) as? Int,
            let date = userDefaults.object(forKey: DeprecatedKey.Date) as? Date
            else { return }
        let challenge = Challenge(name: "", date: date, goal: goal, started: started)
        ChallengeFactory.challenges = [challenge]
        migrated = true
    }
    
    static var migratedToCoreData: Bool {
        get {
            return userDefaults.bool(forKey: Key.MigratedCoreData)
        }
        set {
            userDefaults.set(newValue, forKey: Key.MigratedCoreData)
        }
    }
    
    static func migrateToCoreData(inContext context: NSManagedObjectContext) {
        if let challenges = ChallengeFactory.challenges {
            do {
                try challenges.forEach() { (challenge) in
                    _ = try CDChallenge.findOrCreateChallenge(challenge, inContext: context)
                }
            } catch {
                print(error)
            }
        }
        migratedToCoreData = true
    }

}
