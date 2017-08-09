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
    
    var time: Int {
        if !started || date == nil { return 0 }
        return -Int(date!.timeIntervalSinceNow)
    }
    var progressPercentage: Float {
        let parseResult = Parser.parseToArray(time: time, basedOn: .hour)[0]
        let progressHour = Int(parseResult.time)!
        let percentage = (Float(progressHour) / Float(goal * 24))
        return percentage
    }
    var progressPercentageString: String {
        var percentageText = "100"
        if progressPercentage < 1 {
            percentageText = String.init(format: "%.1f", progressPercentage * 100)
        }
        return percentageText
    }
    var progressDescription: String {
        let results = Parser.parseToArray(time: time, basedOn: .dayHour)
        return results[0].time + results[0].unit + results[1].time + results[1].unit
    }
    
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
    
    class func createChallenge(_ tuple: (String, Int, Date, Bool), inContext context: NSManagedObjectContext) -> Bool {
        
        let attr = castAttr(tuple)
        let found = findChallenge(inContext: context, unique: attr.unique!)
        
        if found != nil {
            return false
        }
        
        
        let cdChallenge = CDChallenge(context: context)
        cdChallenge.unique = attr.unique
        cdChallenge.goal = attr.goal ?? 7
        cdChallenge.date = attr.date
        cdChallenge.started = attr.started
        return true
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
    
    class func updateChallenge(inContext context: NSManagedObjectContext, unique: String, with tuple: (String, Int, Date, Bool)) -> Bool {
        
        let found = findChallenge(inContext: context, unique: unique)
        
        if found != nil {
            let attr = castAttr(tuple)
            found!.unique = attr.unique
            found!.goal = attr.goal ?? found!.goal
            found!.date = attr.date
            found!.started = attr.started
            return true
        }
        
        return false
    }
    
    enum Attribute {
        case name, goal, date, started
    }
    
    class func castAttr(_ attr: (String, Int, Date, Bool)) -> (unique: String?, goal: Int16?, date: NSDate?, started: Bool) {
        return (attr.0, Int16(attr.1), attr.2 as NSDate, attr.3)
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
