//
//  CDChallenge.swift
//  Progressus
//
//  Created by Choong Kai Wern on 11/05/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import CoreData

class CDChallenge: NSManagedObject {
    
    // MARK: Class Function
    class func findOrCreateChallenge(_ challenge: Challenge, inContext context: NSManagedObjectContext) throws -> CDChallenge {
        
        let found = findChallenge(inContext: context, unique: challenge.name)
        
        if found != nil {
            return found!
        }
        
        
        let cdChallenge = CDChallenge(context: context)
        cdChallenge.unique = challenge.name
        cdChallenge.goal = Int16.init(challenge.goal)
        cdChallenge.date = NSDate(timeInterval: 0, since: challenge.date)
        cdChallenge.started = challenge.started
        return cdChallenge
    }
    
    class func findChallenge(inContext context: NSManagedObjectContext, unique: String) -> CDChallenge? {
        let request: NSFetchRequest<CDChallenge> = CDChallenge.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@",unique)
        
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrCreateChallenge -- database inconsistency")
                return match[0]
            }
        } catch {
            print("Something went wrong")
        }
        
        return nil
    }
    
    class func updateChallenge(inContext context: NSManagedObjectContext, unique: String, with dict: [String:Any]) -> Bool {
        
        let found = findChallenge(inContext: context, unique: unique)
        
        if found != nil {
            for (key, value) in dict {
                switch key {
                case "name":
                    // Need to check if there is the duplicate
                    found!.unique = value as? String ?? found!.unique
                case "goal":
                    found!.goal = Int16.init(exactly: value as! Int) ?? found!.goal
                case "date":
                    found!.date = value as? NSDate ?? found!.date
                case "started":
                    found!.started = value as? Bool ?? found!.started
                default:
                    break
                }
            }
            
            return true
        }

        
        return false
    }
    
    class func deleteChallenge(inContext context: NSManagedObjectContext, unique: String) -> Bool {
        
        let found = findChallenge(inContext: context, unique: unique)
        
        if found != nil {
            context.delete(found!)
            return true
        }

        
        return false
    }
    
    class func all(inContext context: NSManagedObjectContext) -> [CDChallenge]? {
        
        let request: NSFetchRequest<CDChallenge> = CDChallenge.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            
            return result
        } catch {
            print(error)
        }
        
        return nil
    }
    
    class func count(inContext context: NSManagedObjectContext) -> Int {
        let request: NSFetchRequest<CDChallenge> = CDChallenge.fetchRequest()
        
        do {
            let result = try context.count(for: request)
            return result
        } catch {
            print(error)
        }
        
        return 0
    }

    func getRecordsDuration() -> [Int] {
        var array: [Int] = []
        let sortDescriptor = NSSortDescriptor(key: "endDate", ascending: true)
        
        let recordsArray = records!.sortedArray(using: [sortDescriptor])
        
        for cdRecord in recordsArray {
            if let record = cdRecord as? CDRecord {
                array.append(record.duration)
            }
        }
        
        return Array(array.suffix(12)) // Return the latest N = 12 records
    }
    
}
