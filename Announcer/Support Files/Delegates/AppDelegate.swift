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
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        }
        
//        registerForPushNotifications()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "org.sstinc.announcer.feed", using: nil) { (task) in
            self.handleAppRefresh()
        }
        
        
        print(UserDefaults.standard.string(forKey: "error") ?? "nothing?")
        print(UserDefaults.standard.string(forKey: "status") ?? "did not refresh")
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("goodbye")
        
        scheduleAppRefresh()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        let request = BGProcessingTaskRequest(identifier: "org.sstinc.announcer.feed")
        
        // Fetch no earlier than 15 minutes from now
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        request.requiresNetworkConnectivity = true
        
        do {
            try BGTaskScheduler.shared.submit(request)
            UserDefaults.standard.set("No Errors, request submitted \(Date())", forKey: "error")
        } catch {
            print("Could not schedule app refresh: \(error)")
            
            UserDefaults.standard.set(error.localizedDescription, forKey: "error")
        }
    }
    
    func handleAppRefresh() {
        // Schedule a new refresh task
        scheduleAppRefresh()
        
        UserDefaults.standard.set("refreshed", forKey: "status")
        
        if let notificationTitle = fetchNotificationsTitle() {
            // New Notification
            // Push
            
            notification(0, postTitle: notificationTitle)
        }
    }
    
    func notification(_ interval: TimeInterval, postTitle: String) {
        let notifManager = LocalNotificationManager()
        
        let date = Date().addingTimeInterval(interval) // in seconds
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M"
        let month = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "yyyy"
        let year = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "d"
        let day = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "h"
        let hour = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "m"
        let minute = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "s"
        let second = Int(dateFormatter.string(from: date))!
        
        notifManager.notifications = [
            NotificationStruct(
                id: "\(UUID().uuidString)",
                title: "New Announcement!",
                body: "\(postTitle)",
                datetime: DateComponents(calendar:
                    Calendar.current, year: year, month: month, day: day, hour: hour, minute: minute, second: second))
        ]
        notifManager.schedule()
        
    }

            
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
