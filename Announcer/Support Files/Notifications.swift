//
//  Notifications.swift
//  FoodStuff
//
//  Created by JiaChen(: on 24/11/19.
//  Copyright © 2019 Aakash Sanjay Mehta. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

struct Notification {
    var id:String
    var title:String
    var body:String
    var datetime:DateComponents
}

class LocalNotificationManager
{
    var notifications = [Notification]()
    
    private func requestAuthorization()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    func listScheduledNotifications() -> [UNNotificationRequest]
    {
        
        var allNotif = [UNNotificationRequest]()
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            
            for notification in notifications {
                print(notification)
                allNotif.append(notification)
            }
        }
        
        return allNotif
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications() {
        for notification in notifications {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default
            content.body     = notification.body
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)
            
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                
                guard error == nil else { return }
                
                print("Notification scheduled! --- ID = \(notification.id)")
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        }
    }
}
