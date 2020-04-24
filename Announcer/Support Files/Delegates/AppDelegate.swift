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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let posts = fetchValues()
        
        var post: Post?
        
        for item in posts {
            if item.title == userInfo["title"] as! String {
                post = item
                break
            }
        }
        
        if let announcementVC = window?.rootViewController as? AnnouncementsViewController, let post = post {
            
            announcementVC.receivePost(with: post)
        }
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let notificationContent = fetchNotificationsTitle() {
            let notifications: [UNMutableNotificationContent] = { () -> [UNMutableNotificationContent] in
                let content = UNMutableNotificationContent()
                content.title = notificationContent.title
                content.body = notificationContent.content
                content.sound = .default
                content.userInfo = ["title" : notificationContent.title]
                
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
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        fatalError()
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        
        print("oh wow")
        
        let posts = fetchValues()
        
        let info = (userActivity!.userInfo as? [String:String])!
        
        var post: Post?
        
        for item in posts {
            if item.title == info["title"] && item.content == info["content"] {
                
                post = item
                break
            }
        }
        
        if let announcementVC = window?.rootViewController as? AnnouncementsViewController, let post = post {
            
            announcementVC.receivePost(with: post)
            
            return true
        }

        
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        print("does this work")
        
        let posts = fetchValues()
        
        let info = (userActivity.userInfo as? [String:String])!
        
        var post: Post?
        
        for item in posts {
            if item.title == info["title"] && item.content == info["content"] {
                
                post = item
                break
            }
        }
        
        if let announcementVC = window?.rootViewController as? AnnouncementsViewController, let post = post {
            
            announcementVC.receivePost(with: post)
            
            return true
        }

        
        return false
    }
    
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        print(error.localizedDescription)
        print("!!")
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
