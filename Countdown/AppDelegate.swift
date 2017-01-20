//
//  AppDelegate.swift
//  Countdown
//
//  Created by Choong Kai Wern on 10/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    /**
     Return the format of date component
     
     ```
     case full
     case short
     ```
     */
    enum DateComponentFormat {
        /// Date Component includes Date, Hour and Minutes
        case full
        /// Date Component includes Hour and Minutes only
        case short
    }
    
    // Need to write a function to remove certain notification only.
    func removeNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // Refactoring Needed - Duplicated Code
    func scheduleNotification(at date: Date, with reminderContent: String, with format: DateComponentFormat) {
        let dateComponent = getDateComponentFor(date: date, basedOn: format)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Congratulation"
        content.body = reminderContent
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "achieveGoalNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
 
    func scheduleNotification(at date: Date, with reminderContent: String) {
        let dateComponent = getDateComponentFor(date: date, basedOn: .short)
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Some Words For You"
        content.body = reminderContent
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "countdownNotification", content: content, trigger: trigger)
        removeNotification()
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (accepted, error) in
            if (!accepted) {
                Settings.isReminderOn = false
            }
        }
        return true
    }
    
    // MARK: Helper Function 
    // Refatoring needed - Mode the method to other class
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

