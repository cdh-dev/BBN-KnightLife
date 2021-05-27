//
//  AppDelegate.swift
//  Glancer
//
//  Created by Vishnu Murale on 5/13/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit
import Alamofire
import AddictiveLib
import UserNotifications
import Moya
import SwiftyJSON
import RealmSwift
import CoreData
import GameKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	
    var window: UIWindow?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		Globals.setData("debug", data: false)
		
		Globals.BundleID = "MAD.BBN.KnightLife"
		Globals.StorageID = "group.KnightLife.MAD.Storage"
		
		application.registerForRemoteNotifications()
        
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewConroller = viewController {
                return
            }
            if error != nil {
                return
            }
            
        }
		
		UNUserNotificationCenter.current().delegate = self
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
			result, error in
			
			if result {
				print("Successfully authorized notifications")
			} else {
				print("Failed to authorize notifications: \(error != nil ? error!.localizedDescription : "None")")
			}
		}
						
		_ = NotificationManager.instance
		
		_ = TodayM
		_ = CourseM
		_ = BlockMetaM
		
        return true
    }
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		// Convert token to String
		let tokenString = deviceToken.map({ String(format: "%02.2hhx", $0) }).joined()
		
		// Store token
		Defaults[.deviceId] = tokenString
				
		// Sync the device profile to server. This will also register the device for push notifications
		DeviceProfile.shared.sync()
	}
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		let queue = DispatchGroup()
		
		PushNotificationManager.instance.handle(payload: userInfo, queue: queue)
		
		queue.notify(queue: .main) {
			completionHandler(.newData)
		}
    }
	
	func applicationDidReceiveMemoryWarning(_ application: UIApplication) {

	}
	
    func applicationWillResignActive(_ application: UIApplication) {
		TodayM.stopTimer()
	}
    
    func applicationDidEnterBackground(_ application: UIApplication){
		
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {

	}
    
    func applicationDidBecomeActive(_ application: UIApplication) {
		TodayM.startTimer()
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler(UNNotificationPresentationOptions.alert)
		HapticUtils.NOTIFICATION.notificationOccurred(.success)
	}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotesDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
