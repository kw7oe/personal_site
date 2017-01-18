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
    
    func removeNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }    
 
    func scheduleNotification(at date: Date, with reminderContent: String) {
        let calender = Calendar(identifier: .gregorian)
        let component = calender.dateComponents(in: .current, from: date)
        let dateComponent = DateComponents(calendar: calender, timeZone: .current, hour: component.hour, minute: component.minute)
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Countdown Reminder"
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
        }
        return true
    }
}

