//
//  ChallengeFactory.swift
//  Progressus
//
//  Created by Choong Kai Wern on 04/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ChallengeFactory {
    
    static var userDefaults = UserDefaults.standard
    static var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    struct Key {
        static let Challenges = "Challenges"
    }
    
    static func createChallenge(_ challenge: Challenge) {
        if let context = container?.viewContext {
            do {
                print("Creating \(challenge.name)")
                _ = try CDChallenge.findOrCreateChallenge(challenge, inContext: context)
                try context.save()
            } catch {
                print("Error: ")
                print(error)
            }
        }
    }
    
    static func allChallenges() -> [Challenge]? {
        if let context = container?.viewContext {
            let cdchallenges =  CDChallenge.all(inContext: context)
            
            guard cdchallenges != nil else {
                return nil
            }
            return cdchallenges?.map({ (challenge) -> Challenge in
                Challenge.init(name: challenge.unique, date: challenge.date, goal: challenge.goal, started: challenge.started)
            })
        }
        
        return nil
    }
    
    
    // MARK: DEPRECATED SOON
    static var challenges: [Challenge]? {
        get {
            if let result = userDefaults.object(forKey: Key.Challenges) as? Data {
                let data = NSKeyedUnarchiver.unarchiveObject(with: result as Data)
                return data as? [Challenge]
            }
            return nil
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            userDefaults.set(data, forKey: Key.Challenges)
        }
    }
    
    static func prependChallenge(with challenge: Challenge) -> Bool {
        if challenges == nil {
            challenges = [challenge]
            return true
        } else {
            let names = challenges!.filter({ (c) -> Bool in
                c.name == challenge.name
            })
            if names.isEmpty {
                challenges!.prepend(element: challenge)
                return true
            }
        }
        
        return false
    }
    
    static func updateChallenge(at position: Int, with challenge: Challenge) {
        if challenges != nil {
            challenges![position] = challenge
        }
    }
    
    static func removeChallenge(at position: Int) {
        challenges?.remove(at: position)
    }

}
