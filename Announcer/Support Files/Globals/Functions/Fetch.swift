//
//  Functions.swift
//  Announcer
//
//  Created by JiaChen(: on 28/5/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

/// Functions meant to fetch data
struct Fetch {
    /**
     Get the labels, tags or categories from the posts.
     
     - returns: An array of labels or tags from the post
     
     This method gets labels, tags or categories, from blog posts and removes duplicates.
     */
    static func labels() -> [String] {
        
        let parser = FeedParser(URL: GlobalLinks.rssURL)
        let result = parser.parse()
        
        switch result {
        case .success(let feed):
            var labels: [String] = []
            
            let entries = feed.atomFeed?.entries ?? []
            
            for i in entries {
                for item in i.categories ?? [] {
                    labels.append(item.attributes?.term ?? "")
                }
                
            }
            
            labels.removeDuplicates()
            
            return labels
            
        case .failure(let error):
            print(error.localizedDescription)
            // Present alert
        }
        return []
    }

    /**
     Fetch blog post from the blogURL
     
     - returns: An array of Announcements stored as Post
     
     - parameters:
        - vc: Takes in Announcement View Controller to present an alert in a case of an error
      
     This method fetches the blog post from the blogURL and will alert the
     user if an error occurs and it is unable to get the announcements
     */
    static func posts(with vc: AnnouncementsViewController) -> [Post] {
        let parser = FeedParser(URL: GlobalLinks.rssURL)
        let result = parser.parse()
        
        switch result {
        case .success(let feed):
            let feed = feed.atomFeed
            let posts = convertFromEntries(feed: (feed?.entries!)!)
            
            UserDefaults.standard.set(posts[0].title, forKey: UserDefaultsIdentifiers.recentsTitle.rawValue)
            UserDefaults.standard.set(posts[0].content, forKey: UserDefaultsIdentifiers.recentsContent.rawValue)
            
            return posts
        case .failure(let error):
            print(error.localizedDescription)
            // Present alert
            DispatchQueue.main.async {
                // No internet error
                let alert = UIAlertController(title: ErrorMessages.unableToLoadPost.title,
                                              message: ErrorMessages.unableToLoadPost.description,
                                              preferredStyle: .alert)
                
                // Try to reload and hopefully it works
                let tryAgain = UIAlertAction(title: "Try Again", style: .default, handler: { _ in
                    vc.reload(UILabel())
                })
                
                alert.addAction(tryAgain)
                
                alert.preferredAction = tryAgain
                
                // Open the settings app
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                    UIApplication.shared.open(GlobalLinks.settingsURL, options: [:]) { (success) in
                        print(success)
                    }
                }))
                
                // Just dismiss it
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                vc.present(alert, animated: true, completion: nil)
            }
        }
        
        return []
    }

    /**
     Fetches latest blog post for notifications
     
     - returns: A tuple with the title and content of the post or `nil` if no new content has been posted
     
     This method will fetch the latest posts from the RSS feed and if it is a new post,
     it will return the title and content for notifications, otherwise, it will return nil.
     */
    static func latestNotification() -> (title: String, content: String)? {
        let parser = FeedParser(URL: GlobalLinks.rssURL)
        let result = parser.parse()
        
        switch result {
        case .success(let feed):
            let feed = feed.atomFeed
            
            let posts = convertFromEntries(feed: (feed?.entries)!)
            
            let defaultsTitle = UserDefaults.standard.string(forKey: UserDefaultsIdentifiers.recentsTitle.rawValue)
            let defaultsContent = UserDefaults.standard.string(forKey: UserDefaultsIdentifiers.recentsContent.rawValue)
            
            if posts[0].title != defaultsTitle && posts[0].content != defaultsContent {
                
                UserDefaults.standard.set(posts[0].title,
                                          forKey: UserDefaultsIdentifiers.recentsTitle.rawValue)
                
                UserDefaults.standard.set(posts[0].content,
                                          forKey: UserDefaultsIdentifiers.recentsContent.rawValue)
                
                let title = convertFromEntries(feed: (feed?.entries!)!).first!.title
                let content = convertFromEntries(feed: (feed?.entries!)!).first!.content
                
                let formattedContent = content.htmlToAttributedString?.htmlToString
                
                return (title: title, content: formattedContent!)
            }
            
        default:
            break
        }
        
        return nil
    }

    /**
    Fetches the blog posts from the blogURL

    - returns: An array of `Post` from the blog
    - important: This method will handle errors it receives by returning an empty array

     This method will fetch the posts from the blog and return it as [Post]
    */
    static func values() -> [Post] {
        let parser = FeedParser(URL: GlobalLinks.rssURL)
        let result = parser.parse()
        
        switch result {
        case .success(let feed):
            let feed = feed.atomFeed
            
            return convertFromEntries(feed: (feed?.entries)!)
        default:
            break
        }
        
        return []
    }

    /**
     Converts an array of `AtomFeedEntry` to an array of `Post`
     
     - returns: An array of `Post`
     
     - parameters:
        - feed: An array of `AtomFeedEntry`
      
     This method will convert the array of `AtomFeedEntry` from `FeedKit` to an array of `Post`.
    */
    static func convertFromEntries(feed: [AtomFeedEntry]) -> [Post] {
        var posts = [Post]()
        for entry in feed {
            let cat = entry.categories ?? []
            
            posts.append(Post(title: entry.title ?? "",
                              content: (entry.content?.value) ?? "",
                              date: entry.published ?? Date(),
                              pinned: false,
                              read: false,
                              reminderDate: nil,
                              categories: {
                                var categories: [String] = []
                                for i in cat {
                                    categories.append((i.attributes?.term!)!)
                                }
                                return categories
            }()))
            
        }
        return posts
    }
}
