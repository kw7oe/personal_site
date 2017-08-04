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
        
        let request: NSFetchRequest<CDChallenge> = CDChallenge.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", challenge.name)
        
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "findOrCreateChallenge -- database inconsistency")
                return match[0]
            }
        } catch {
            print("Something went wrong")
            throw error
        }
        
        
        let cdChallenge = CDChallenge(context: context)
        cdChallenge.unique = challenge.name
        cdChallenge.goal = Int16.init(challenge.goal)
        cdChallenge.date = NSDate(timeInterval: 0, since: challenge.date)
        cdChallenge.started = challenge.started
        return cdChallenge
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
    
    class func printData(inContext context: NSManagedObjectContext) {
        let request: NSFetchRequest<CDChallenge> = CDChallenge.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            
            for cdChallenge in result {
                print("Name: \(cdChallenge.unique)")
                print("Goal: \(cdChallenge.goal)")
                print("Started: \(cdChallenge.started)")
            }
            
            
        } catch {
            print(error)
        }
    }
}
