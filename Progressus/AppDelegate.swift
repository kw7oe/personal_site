//
//  AppDelegate.swift
//  Countdown
//
//  Created by Choong Kai Wern on 10/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        resetStateIfUITesting()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (accepted, error) in
            if (!accepted) {
                Settings.isReminderOn = false
            }
        }
        
        if !DataMigration.migrated {
            DataMigration.migrateData()
        }
        
        if !DataMigration.migratedToCoreData {
            DataMigration.migrateToCoreData(inContext: persistentContainer.viewContext)
        }
        
        if ReminderFactory.shouldRemovedPendingNotifications {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("Removing...")
            ReminderFactory.pendingNotificationsRemoved = true
        }
        
        return true
    }
    
    private func resetStateIfUITesting() {
        if ProcessInfo.processInfo.arguments.contains("UI-Testing") {
            // Reset User Defaults
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            
            // Reset Core Data
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CDChallenge")
            let delRequest = NSBatchDeleteRequest(fetchRequest: request)
            let context = persistentContainer.viewContext
            let coord = persistentContainer.persistentStoreCoordinator
            
            do {
                try coord.execute(delRequest, with: context)
            } catch {
                print(error)
            }
            
            // Initialize Data
            _ = CDChallenge.createChallenge(("Workout", 7, Date.init(), true), inContext: context)
        }
    }
    
    // MARK: - Core Data stack
    static var container: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

