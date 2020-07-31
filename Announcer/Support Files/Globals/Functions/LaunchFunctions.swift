//
//  Spotlight.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

// Spotlight Search
import CoreSpotlight
import MobileCoreServices

// Safari View Controller
import SafariServices

/**
 Launches post using the post title
 
 - parameters:
    - postTitle: The title of the post to be found
 
 - note: This method is generally for search and notifications
 
 This method launches post using the post title and will show an open in safari button if there is an error.
*/
func launchPost(withTitle postTitle: String) {
    let posts = Fetch.values()
    
    var post: Post?
    
    // Finding the post to present
    for item in posts where item.title == postTitle {
        post = item
        
        break
    }
    
    var announcementVC: AnnouncementsViewController!
    
    if I.wantToBeMac || I.mac {
        if let splitVC = UIApplication.shared.windows.first?.rootViewController as? SplitViewController {
            announcementVC = splitVC.announcementVC!
        }
        
    } else {
        let window = UIApplication.shared.windows.first
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            announcementVC = navigationController.topViewController as? AnnouncementsViewController
        }
    }
    
    if let post = post {
        // Marking post as read
        var readAnnouncements = ReadAnnouncements.loadFromFile() ?? []
        
        readAnnouncements.append(post)
        ReadAnnouncements.saveToFile(posts: readAnnouncements)
        
        // Handles when post is found
        announcementVC.receivePost(with: post)
        
    } else {
        // Handle when unable to get post
        // Show an alert to the user to tell them that the post was unable to be found :(

        print("failed to get post :(")

        let alert = UIAlertController(title: ErrorMessages.unableToLaunchPost.title,
                                      message: ErrorMessages.unableToLaunchPost.description,
                                      preferredStyle: .alert)

        // If user opens post in Safari, it will simply bring them to student blog home page
        let openInSafari = UIAlertAction(title: "Open in Safari", style: .default, handler: { (_) in
            let svc = SFSafariViewController(url: URL(string: GlobalLinks.blogURL)!)
            
            announcementVC.present(svc, animated: true)
        })
        
        alert.addAction(openInSafari)
        
        alert.preferredAction = openInSafari
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        announcementVC.present(alert, animated: true)
        
    }

}

/**
 Continuing userActivity from Spotlight Search
 
 - parameters:
    - userActivity: UserActivity received from Delegate
 
 This method opens the post that is received from spotlight search.
*/
func continueFromCoreSpotlight(with userActivity: NSUserActivity) {
    if userActivity.activityType == CSSearchableItemActionType {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            launchPost(withTitle: uniqueIdentifier)
        }
    }
}
