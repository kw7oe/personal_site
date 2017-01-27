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
        static let Goal = "Goal"
        static let Date = "Date"
        static let GoalDate = "Goal Date"
        static let ReminderOn = "Reminder On"
        static let ReminderContent = "Reminder Content"
        static let ReminderTime = "Reminder Time"
        static let Reminders = "Reminders"
    }
    
    static var goal: Int {
        get {
            if let result = settings.object(forKey: Key.Goal) as? Int {
                return result
            }
            settings.set(7, forKey: Key.Goal)
            return 7
        }
        set { settings.set(newValue, forKey: Key.Goal) }
        
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
        set { settings.set(newValue, forKey: Key.Date) }
    }
    
    static var goalDate: Date {
        return date.addingTimeInterval(Double(goal * 24 * 60 * 60))
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
    
    static var reminders: [Reminder]? {
        get {
            if let result = settings.object(forKey: Key.Reminders) as? Data {
                let data = NSKeyedUnarchiver.unarchiveObject(with: result as Data)
                return data as! [Reminder]?
            }
            return nil
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            settings.set(data, forKey: Key.Reminders)
        }
    }

    static func appendReminder(reminder: Reminder) -> Bool {
        var result: Bool;
        if let count = reminders?.count, count < reminderCounts {
            reminders!.append(reminder)
            result = false
        } else {
            let identifier = reminders!.first!.identifier
            reminder.identifier = identifier
            reminders!.removeFirst()
            reminders!.append(reminder)
            result = true
        }
        
        NotificationServices().scheduleNotification(with: reminder, basedOn: .short)
        return result
    }
    
    static func updateReminderAt(index: Int, with reminder: Reminder) {
        reminders![index] = reminder
        NotificationServices().scheduleNotification(with: reminder, basedOn: .short)
    }
    
  }
