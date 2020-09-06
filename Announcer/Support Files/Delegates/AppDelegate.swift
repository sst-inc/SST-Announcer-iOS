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
        
        completionHandler(.newData)
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
