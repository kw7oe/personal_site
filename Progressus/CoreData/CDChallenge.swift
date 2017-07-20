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
        return cdChallenge
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
                for cdRecord in cdChallenge.records! {
                    if let record = cdRecord as? CDRecord {
                        print("Duration: \(record.duration)")
                    }
                }
            }
            
        } catch {
            print(error)
        }
    }
}
