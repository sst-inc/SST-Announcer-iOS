//
//  AppDelegate.swift
//  Announcer
//
//  Created by JiaChen(: on 25/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit
import UserNotifications
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Checks to ensure the URL is correct.
        #if DEBUG
        #else
        if blogURL != "http://studentsblog.sst.edu.sg" {
            fatalError("incorrect URL")
        }
        #endif
        
        // Fetch data every five minutes.
        // This deprecated thing is for the next exco to deal with.
        UIApplication.shared.setMinimumBackgroundFetchInterval(300)
        
        //Ask for notification authorization
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }

        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let notificationContent = fetchNotificationsTitle() {
            let notifications: [UNMutableNotificationContent] = { () -> [UNMutableNotificationContent] in
                let content = UNMutableNotificationContent()
                content.title = notificationContent.title
                content.body = notificationContent.content
                content.sound = .default
                
                return [content]
            }()
            
            for notification in notifications {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "NewPost", content: notification, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        }
        
    }
    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("goodbye")
//
//        scheduleAppRefresh()
//    }
    
//    func applicationWillTerminate(_ application: UIApplication) {
//        scheduleAppRefresh()
//    }
//
//    func scheduleAppRefresh() {
//        let request = BGProcessingTaskRequest(identifier: "org.sstinc.announcer.feed")
//
//        // Fetch no earlier than 15 minutes from now
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
//        request.requiresNetworkConnectivity = true
//
//        do {
//            try BGTaskScheduler.shared.submit(request)
//            UserDefaults.standard.set("No Errors, request submitted \(Date())", forKey: "error")
//        } catch {
//            print("Could not schedule app refresh: \(error)")
//
//            UserDefaults.standard.set(error.localizedDescription, forKey: "error")
//        }
//    }
//
//    func handleAppRefresh() {
//        // Schedule a new refresh task
//        scheduleAppRefresh()
//
//        UserDefaults.standard.set("refreshed", forKey: "status")
//
//        if let notificationTitle = fetchNotificationsTitle() {
//            // New Notification
//            // Push
//
//            notification(0, postTitle: notificationTitle)
//        }
//    }

            
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
}
