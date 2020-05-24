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
import SafariServices

import CoreSpotlight
import MobileCoreServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    static let backgroundTaskIdentifier = Bundle.main.bundleIdentifier! + ".new-announcement"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Checks to ensure the URL is correct.
        // Safeguard against my 3am stupidity
        #if DEBUG
        #else
        if blogURL != "http://studentsblog.sst.edu.sg" {
            fatalError("incorrect URL")
        }
        #endif
        
        //Ask for notification authorization
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
                print("noooo i demand notifications!!!!!")
            }
        }
        
        // Notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Performing Background Fetch for new posts
        BGTaskScheduler.shared.register(forTaskWithIdentifier: AppDelegate.backgroundTaskIdentifier, using: .main) { task in
            
            // Check if there is a new post
            if let notificationContent = fetchNotificationsTitle() {
                // Notify the user if there is a new post
                self.pushNotification(with: notificationContent.title, content: notificationContent.content)
            }
            
            task.setTaskCompleted(success: true)
            
            // Handle running out of time
            task.expirationHandler = {
                print("uh oh")
            }
            
            // Schedule the next background task
            self.scheduleBackgroundTaskIfNeeded()
        }
        
        // Start background task
        scheduleBackgroundTaskIfNeeded()
        
        // Set project version
        let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        UserDefaults.standard.set(versionNumber, forKey: "versionNumber")
        
        // Set project build
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        UserDefaults.standard.set(buildNumber, forKey: "buildNumber")
        
        return true
    }
    
    // Testing if background task works
    // Run this below in debugger
    // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"sg.edu.sst.panziyue.Announcer.new-announcement"]
    func scheduleBackgroundTaskIfNeeded() {
        let taskRequest = BGProcessingTaskRequest(identifier: AppDelegate.backgroundTaskIdentifier)
        taskRequest.requiresNetworkConnectivity = true
        
        do {
            try BGTaskScheduler.shared.submit(taskRequest)
        } catch {
            print("Unable to schedule background task: \(error)")
        }
        // To test if background tasks work, add a breakpoint here
        // Then run the code above in the debugger
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
    
    
    // Push the notification to the user
    func pushNotification(with postTitle: String, content postContent: String) {
        let identifier = "new-announcement"
        let content = UNMutableNotificationContent()
        
        content.title = "📢 \(postTitle)"
        content.body = postContent
        
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error showing error user notification: \(error)")
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // Calls when user opens app from a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        openPost(with: response.notification)
        
        completionHandler()
    }
    
    /// Open up the post from notification
    func openPost(with notification: UNNotification) {
        let notificationContent = notification.request.content
        
        var postTitle = notificationContent.title
        postTitle.removeFirst(2)
        
        launchPost(withTitle: postTitle)
    }
    
    // Catching userActivity for iOS 12 and below
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                launchPost(withTitle: uniqueIdentifier)
            }
        }
        
        return true
    }
}
