//
//  Settings.swift
//  Countdown
//
//  Created by Choong Kai Wern on 15/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

// MARK: Settings Model
class Settings {
    
    static var settings = UserDefaults.standard
    
    struct Key {
        static let Goal = "Goal"
        static let Date = "Date"
        static let ReminderOn = "Reminder On"
        static let ReminderContent = "Reminder Content"
        static let ReminderTime = "Reminder Time"
    }
    
    static var goal: Int {
        get {
            if let result = settings.object(forKey: Key.Goal) as? Int {
                return result
            }
            settings.set(7, forKey: Key.Goal)
            return 7
        }
        set {
            settings.set(newValue, forKey: Key.Goal)        }
        
    }
    
    static var date: Date {
        get {
            if let result = settings.object(forKey: Key.Date) as? Date {
                return result
            }
            
            // Code Smell: Code Duplication
            let date = Date.init()
            settings.set(date, forKey: Key.Date)
            return date
        }
        set {
            settings.set(newValue, forKey: Key.Date)
        }
    }
    
    
    static var isReminderOn: Bool {
        get {
            if let result = settings.object(forKey: Key.ReminderOn) as? Bool {
                return result
            }
            settings.set(true, forKey: Key.ReminderOn)
            return true
        }
        
        set {
            settings.set(newValue, forKey: Key.ReminderOn)
        }
    }
    
    static var reminderContent: String {
        get {
            if let result = settings.object(forKey: Key.ReminderContent) as? String {
                return result
            }
            let content = "Nothing can stop the man with the right mental attitude from achieving his goal."
            settings.set(content, forKey: Key.ReminderContent)
            return content
        }
        
        set {
            settings.set(newValue, forKey: Key.ReminderContent)
        }
    }
    
    static var reminderTime: Date {
        get {
            if let result = settings.object(forKey: Key.ReminderTime) as? Date {
                return result
            }
            
            // Code Smell: Code Duplication
            let date = Date.init()
            settings.set(date, forKey: Key.ReminderTime)
            return date
        }
        
        set {
            settings.set(newValue, forKey: Key.ReminderTime)
        }
    }
}
