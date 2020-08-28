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
import PushNotifications

#if DEBUG
import Gedatsu
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let pushNotifications = PushNotifications.shared
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Checks to ensure the URL is correct.
        // Safeguard against my 3am stupidity
        #if DEBUG
        Gedatsu.open()
        #else
        if GlobalLinks.blogURL != "http://studentsblog.sst.edu.sg" {
            I.wantToDie
        }
        #endif
        
        //Ask for notification authorization
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) {
            (granted, _) in
            if !granted {
                // User did not give us notification access :(
                print("Something went wrong")
                print("noooo i demand notifications!!!!!")
            }
        }
        
        // Notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Performing Background Fetch for new posts
        BGTaskScheduler.shared.register(forTaskWithIdentifier: GlobalIdentifier.backgroundTask, using: .main) { task in
            
            // Check if there is a new post
            if let notificationContent = Fetch.latestNotification() {
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
        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            UserDefaults.standard.set(versionNumber, forKey: UserDefaultsIdentifiers.versionNumber.rawValue)
        }
        
        // Set project build
        if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            UserDefaults.standard.set(buildNumber, forKey: UserDefaultsIdentifiers.buildNumber.rawValue)
        }
        
        self.pushNotifications.start(instanceId: Keys.push)
        
        self.pushNotifications.registerForRemoteNotifications()
        
        try? self.pushNotifications.addDeviceInterest(interest: "all")
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.pushNotifications.handleNotification(userInfo: userInfo)
    }

    // swiftlint:disable all
    /**
    Schedules the new announcement background task
    
     The identifier is `sg.edu.sst.panziyue.Announcer.new-announcement`
     
     ---
    # Debugging Background Tasks
     Running this line in the debugger to instantly manually background refresh.
     Background refresh takes a while so this is the easier way to do it and test it out.
     
    [Developer Article](https://developer.apple.com/documentation/backgroundtasks/starting_and_terminating_tasks_during_development)
     
    ```
     e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"sg.edu.sst.panziyue.Announcer.new-announcement"]
     ```
     */
    // swiftlint:enable all
    func scheduleBackgroundTaskIfNeeded() {
        let taskRequest = BGProcessingTaskRequest(identifier: GlobalIdentifier.backgroundTask)
        taskRequest.requiresNetworkConnectivity = true
        
        do {
            try BGTaskScheduler.shared.submit(taskRequest)
        } catch {
            print("Unable to schedule background task: \(error)")
        }
        // To test if background tasks work, add a breakpoint here
        // Then run the code above in the debugger
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        let window = UIApplication.shared.windows.first
        window?.rootViewController = Storyboards.timetable.instantiateInitialViewController()

        return true
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        if let userActivity = userActivity {
            continueFromCoreSpotlight(with: userActivity)
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        //
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Push the notification to the user
    func pushNotification(with postTitle: String, content postContent: String) {
        let content = UNMutableNotificationContent()
        
        content.title = "📢 \(postTitle)"
        content.body = postContent
        
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: GlobalIdentifier.newNotification,
                                            content: content,
                                            trigger: nil)
        
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
                                withCompletionHandler completionHandler: @escaping
                                    (UNNotificationPresentationOptions) -> Void) {
        
        if #available(iOS 14.0, *) {
            completionHandler([.badge, .sound, .banner])
        } else {
            completionHandler([.badge, .sound, .alert])
        }
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
        
        launch(getPost(fromTitle: postTitle))
    }
}
