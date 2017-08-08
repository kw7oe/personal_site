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
    static let reminderCounts = 3
    struct Key {
        static let ReminderOn = "Reminder On"
        static let StartOnReset = "Start On Reset"
        static let Theme = "Theme"
        static let ColorIndex = "Color Index"
    }
    
    static var isReminderOn: Bool {
        get {
            if let result = settings.object(forKey: Key.ReminderOn) as? Bool {
                return result
            }
            settings.set(true, forKey: Key.ReminderOn)
            return true
        }
        
        set { settings.set(newValue, forKey: Key.ReminderOn) }
    }
    
    // MARK: Utility
    static var startOnReset: Bool {
        get {
            if let result = settings.object(forKey: Key.StartOnReset) as? Bool {
                return result
            }
            return false
        }
        set {
            settings.set(newValue, forKey: Key.StartOnReset)
        }
    }
    
    // MARK: DARK THEME
    static var theme: Theme {
        get {
            if let result = settings.object(forKey: Key.Theme) as? String {
                return Theme(rawValue: result) ?? .light
            }
            return .light
        }
        set {
            settings.set(newValue.rawValue, forKey: Key.Theme)
        }
    }
    
    // MARK: Color Selection
    static var colorIndex: Int {
        get {
            return settings.integer(forKey: Key.ColorIndex)
        }
        set {
            settings.set(newValue, forKey: Key.ColorIndex)
        }
    }
}


