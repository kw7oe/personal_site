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
        static let Challenges = "Challenges"
        static let ReminderOn = "Reminder On"
        static let ReminderContent = "Reminder Content"
        static let ReminderTime = "Reminder Time"
        static let Reminders = "Reminders"
        static let ReminderIdentifiers = "Reminder Identifiers"
        static let StartOnReset = "Start On Reset"
        static let Theme = "Theme"
        static let ColorIndex = "Color Index"
        // Internal
        static let Migrated = "Migrated"
        static let RemovePendingNotifications = "Remove Pending Notifications"
    }
    
    // Migration of Data
    static var migrated: Bool {
        get {
            return settings.bool(forKey: Key.Migrated)
        }
        set {
            settings.set(newValue, forKey: Key.Migrated)
        }
    }
    static func migrateData() {
        let started = settings.bool(forKey: "Date Started")
        guard let goal = settings.object(forKey: "Goal") as? Int,
              let date = settings.object(forKey: "Date") as? Date
              else { return }
        let challenge = Challenge(name: "", date: date, goal: goal, started: started)
        challenges = [challenge]
        migrated = true
    }
    
    // Previous Reminders
    static var shouldRemovedPendingNotifications: Bool {
        print(!pendingNotificationsRemoved)
        print(reminders?.isEmpty ?? true)
        return !pendingNotificationsRemoved && (reminders?.isEmpty ?? true)
    }
    
    static var pendingNotificationsRemoved: Bool {
        get {
            return settings.bool(forKey: Key.RemovePendingNotifications)
        }
        set {
            settings.set(newValue, forKey: Key.RemovePendingNotifications)
        }
    }
    
    // MARK: Challenges
    static var challenges: [Challenge]? {
        get {
            if let result = settings.object(forKey: Key.Challenges) as? Data {
                let data = NSKeyedUnarchiver.unarchiveObject(with: result as Data)
                return data as? [Challenge]
            }
            return nil
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            settings.set(data, forKey: Key.Challenges)
        }
    }
    
    static func prependChallenge(with challenge: Challenge) {
        if challenges == nil {
            challenges = [challenge]
        } else {
            challenges!.prepend(element: challenge)
        }
    }
    
    static func updateChallenge(at position: Int, with challenge: Challenge) {
        if challenges != nil {
            challenges![position] = challenge
        }
    }
    
    static func removeChallenge(at position: Int) {
        challenges?.remove(at: position)
    }

    // MARK: Reminders
    static var reminders: [Reminder]? {
        get {
            if let result = settings.object(forKey: Key.Reminders) as? Data {
                let data = NSKeyedUnarchiver.unarchiveObject(with: result as Data)
                return data as? [Reminder]
            }
            return nil
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            settings.set(data, forKey: Key.Reminders)
        }
    }
    
    static var reminderIdentifier: [String] {
        get {
            if let result = settings.object(forKey: Key.ReminderIdentifiers) as? [String] {
                return result
            }
            
            let array = [
                "Reminder 1",
                "Reminder 2",
                "Reminder 3"
            ]
            settings.set(array, forKey: Key.ReminderIdentifiers)
            return array
        }
        set {
            settings.set(newValue, forKey: Key.ReminderIdentifiers)
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
        
        set { settings.set(newValue, forKey: Key.ReminderOn) }
    }
    
    // MARK: Class Functions
    static func appendReminder(reminder: Reminder)  {
        if reminders == nil { // Reminders Does Not Exists yet
            reminders = [reminder]
        } else if reminders!.count < reminderCounts { // Reminders Count < reminderCounts
            reminders!.append(reminder)
        }
        
        NotificationServices().scheduleNotification(with: reminder, basedOn: .short)
    }
    
    static func removeReminder(at index: Int, withIdentifier identifier: String) {
        reminderIdentifier.prepend(element: identifier)
        Settings.reminders?.remove(at: index)
    }
    
    static func updateReminderAt(index: Int, with reminder: Reminder) {
        reminders![index] = reminder
        NotificationServices().scheduleNotification(with: reminder, basedOn: .short)
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


