//
//  NotificationServices.swift
//  Countdown
//
//  Created by Choong Kai Wern on 22/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationServices {
    
    var delegate: NotificationServicesDelegate!
    
    /**
    Remove notification with spefific identifiers.
     - Parameter withIdentifiers: Identifiers of the notifications to be remove.
    */
    func removeNotification(withIdentifiers identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    /**
    Schedule Notification. To call this method, first, you must implement the `NotificationServices Delegate`:
     
     ```
      class ViewController: NotificationServicesDelegate {
         func nameOfIdentifiers() -> String
         func contentOfNotification() -> String
         func willRepeat() -> Bool
         func dateFormat() -> DateComponentFormat
         func date() -> Date
     }
     ```
     Then set delegate as self:
     ```
        var notificationServices = NotificationServices()
        notificationServices.delegate = self
     
     ```
    */
    func scheduleNotification() {
        let dateComponent = getDateComponentFor(date: delegate.date(), basedOn: delegate.dateFormat())
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: delegate.willRepeat())
        let content = UNMutableNotificationContent()
        content.body = delegate.contentOfNotification()
        content.sound = UNNotificationSound.default()
        
        removeNotification(withIdentifiers: [delegate.nameOfIdentifiers()])
        
        let request = UNNotificationRequest(identifier: delegate.nameOfIdentifiers(), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func scheduleNotification(with reminder: Reminder, basedOn format: DateComponentFormat) {
        let dateComponent = getDateComponentFor(date: reminder.time, basedOn: format)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let content = UNMutableNotificationContent()
        content.body = reminder.content
        content.sound = UNNotificationSound.default()
        
        removeNotification(withIdentifiers: [reminder.identifier])
        
        let request = UNNotificationRequest(identifier: reminder.identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func promptToAllowNotification(completionHandler: @escaping (Bool, Error?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: completionHandler)
        
    }
    
    // MARK: Helper Function
    func getDateComponentFor(date: Date, basedOn format: DateComponentFormat) -> DateComponents {
        let calender = Calendar(identifier: .gregorian)
        let component = calender.dateComponents(in: .current, from: date)
        var dateComponent = DateComponents(calendar: calender, timeZone: .current)
        switch format {
        case .full:
            dateComponent.year = component.year
            dateComponent.month = component.month
            dateComponent.day = component.day
            fallthrough
        case .short:
            dateComponent.hour = component.hour
            dateComponent.minute = component.minute
        }
        
        return dateComponent
    }    
}



/**
 Return the format of date component
 
 ```
 case full: Date Component includes Date, Hour and Minutes
 case short: Date Component includes Hour and Minutes only
 ```
 */
enum DateComponentFormat {
    /// Date Component includes Date, Hour and Minutes
    case full
    /// Date Component includes Hour and Minutes only
    case short
}
    
