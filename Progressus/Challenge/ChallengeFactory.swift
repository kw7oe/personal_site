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

// MARK: DEPRECATED (Only retained for testing)
class ChallengeFactory {
    
    static var userDefaults = UserDefaults.standard
    
    struct Key {
        static let Challenges = "Challenges"
    }
    
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
