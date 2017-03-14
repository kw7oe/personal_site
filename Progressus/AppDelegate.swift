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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, error) in
            if (!accepted) {
                Settings.isReminderOn = false
            }
        }
        
        if !Settings.migrated {
            Settings.migrateData()
        }
        
        return true
    }
}

