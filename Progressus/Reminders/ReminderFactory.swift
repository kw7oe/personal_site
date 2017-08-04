//
//  ReminderFactory.swift
//  Progressus
//
//  Created by Choong Kai Wern on 04/08/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

class ReminderFactory {
    
    static var userDefaults = UserDefaults.standard
    static let reminderCounts = 3
    struct Key {
        static let ReminderOn = "Reminder On"
        static let ReminderContent = "Reminder Content"
        static let ReminderTime = "Reminder Time"
        static let Reminders = "Reminders"
        static let ReminderIdentifiers = "Reminder Identifiers"
        static let RemovePendingNotifications = "Remove Pending Notifications"
    }
    
    // Previous Reminders
    static var shouldRemovedPendingNotifications: Bool {
        return !pendingNotificationsRemoved && (reminders?.isEmpty ?? true)
    }
    
    static var pendingNotificationsRemoved: Bool {
        get {
            return userDefaults.bool(forKey: Key.RemovePendingNotifications)
        }
        set {
            userDefaults.set(newValue, forKey: Key.RemovePendingNotifications)
        }
    }
    
    static var reminders: [Reminder]? {
        get {
            if let result = userDefaults.object(forKey: Key.Reminders) as? Data {
                let data = NSKeyedUnarchiver.unarchiveObject(with: result as Data)
                return data as? [Reminder]
            }
            return nil
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            userDefaults.set(data, forKey: Key.Reminders)
        }
    }
    
    static var reminderIdentifier: [String] {
        get {
            if let result = userDefaults.object(forKey: Key.ReminderIdentifiers) as? [String] {
                return result
            }
            
            let array = [
                "Reminder 1",
                "Reminder 2",
                "Reminder 3"
            ]
            userDefaults.set(array, forKey: Key.ReminderIdentifiers)
            return array
        }
        set {
            userDefaults.set(newValue, forKey: Key.ReminderIdentifiers)
        }
    }
    
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
        ReminderFactory.reminders?.remove(at: index)
    }
    
    static func updateReminderAt(index: Int, with reminder: Reminder) {
        reminders![index] = reminder
        NotificationServices().scheduleNotification(with: reminder, basedOn: .short)
    }
}
