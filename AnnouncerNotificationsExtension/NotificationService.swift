//
//  NotificationService.swift
//  AnnouncerNotificationsExtension
//
//  Created by JiaChen(: on 15/12/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UserNotifications
import OneSignal

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    // RSS URL
    let rssURL = URL(string: "http://studentsblog.sst.edu.sg/feeds/posts/default")!
    
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            if UserDefaults.standard.string(forKey: "previous notif") != fetchNotificationsTitle() && fetchNotificationsTitle() != "error"{
                bestAttemptContent.title = "\(bestAttemptContent.title)"
                bestAttemptContent.body = fetchNotificationsTitle()
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    func fetchNotificationsTitle() -> String {
        let parser = FeedParser(URL: rssURL)
        let result = parser.parse()
        
        switch result {
        case .success(let feed):
            print(feed)
            let feed = feed.atomFeed
            return convertFromEntries(feed: (feed?.entries!)!)
        case .failure(let error):
            return "error"
        }
    }


    // Convert Enteries to Posts
    func convertFromEntries(feed: [AtomFeedEntry]) -> String{
        return feed.first?.title ?? ""
    }



}
