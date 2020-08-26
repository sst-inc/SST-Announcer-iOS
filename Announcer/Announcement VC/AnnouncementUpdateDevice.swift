//
//  AnnouncementUpdateDevice.swift
//  Announcer
//
//  Created by JiaChen(: on 26/8/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices
import UserNotifications
import UIKit

extension AnnouncementsViewController {
    /// Update badge of number of unread posts
    func badgeItems() {
        if posts == nil {
            return
        }
        
        let readPosts = ReadAnnouncements.loadFromFile() ?? []
        
        let readCount = posts.filter {
            readPosts.contains($0)
        }.count
        
        let badge = 25 - readCount
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (granted, _) in
            
            if granted {
                DispatchQueue.main.async {
                    // User did not give us notification access :(
                    UIApplication.shared.applicationIconBadgeNumber = badge
                }
            }
        }
    }
    
    /// Save items to spotlight search
    func addItemsToCoreSpotlight() {
        
        /// So that it does not crash when `posts` gets forced unwrapped
        /// Handles instances when `posts` is `nil`, for instance, when reloading
        if posts == nil {
            return
        }
        
        /// `posts` converted to `CSSearchableItems`
        let items: [CSSearchableItem] = posts.map({ post in
            let attributeSet =  CSSearchableItemAttributeSet(itemContentType: kUTTypeHTML as String)
            
            /// Setting the title of the post
            attributeSet.title = post.title
            
            /// Set the keywords for the `CSSearchableItem` to make it easier to find on Spotlight Search
            attributeSet.keywords = post.categories
            
            /// Setting the content description so when the user previews the
            /// announcement through spotlight search, they can see the content description
            let content = post.content.condenseLinebreaks()
            attributeSet.contentDescription = content.htmlToAttributedString?.htmlToString
            
            // Creating the searchable item from the attributesSet
            let item = CSSearchableItem(uniqueIdentifier: "\(post.title)",
                                        domainIdentifier: Bundle.main.bundleIdentifier!,
                                        attributeSet: attributeSet)
            
            // Setting the expiration date to distant future
            // So that it will not expire, at least not in 2000 years
            item.expirationDate = Date.distantFuture
            
            // Return the item
            return item
        })
        
        // Index the items
        CSSearchableIndex.default().indexSearchableItems(items) { error in
            // Make sure there is no error indexing everything
            if let error = error {
                // An error occurred when indexing
                // I do not exactly have a back-up plan on what to do in this case
                // Mainly just have the spotlight search not work
                print("Indexing error: \(error.localizedDescription)")
            } else {
                // Items were indexed. We did it.
                print("Search items successfully indexed!")
            }
        }
    }
    
    /// Reload filter with new filter query
    func reloadFilter() {
        // Handling when a tag is selected from the ContentViewController
        if filter != "" {
            // Setting search bar text
            self.searchField.text = "[\(filter)]"
            
            // Reloading announcementTableView with the new search field tet
            self.announcementTableView.reloadData()
            
            // Updating search bar
            self.searchBar(self.searchField, textDidChange: "[\(filter)]")
            
            // Reset filter
            filter = ""
        } else {
            self.announcementTableView.reloadData()
        }
    }
    
    /// Get filter view controller and open it up
    func openFilter() {
        // Getting navigation controller from filter storyboard
        if let filterNVC = Storyboards.filter.instantiateInitialViewController() as? UINavigationController {

            // Get filterViewController from navigationController
            if let filterVC = filterNVC.children.first as? FilterTableViewController {

                // Set onDismiss actions that will run when we dismiss the other vc
                // this void should reload tableview etc.
                filterVC.onDismiss = {
                    // Set search bar text
                    self.searchField.text = "[\(filter)]"

                    // Reload table view with new content
                    self.announcementTableView.reloadData()

                    // Run search function
                    self.searchBar(self.searchField, textDidChange: "[\(filter)]")

                    // Reset filters
                    filter = ""
                }
            }

            // Present filter navigation controller
            self.present(filterNVC, animated: true)
        }
    }
}
