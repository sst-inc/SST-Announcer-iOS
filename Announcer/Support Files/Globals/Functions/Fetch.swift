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
import WidgetKit
import FeedKit

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
            
            DispatchQueue.global().async {
                let announcements: [Announcement] = posts.prefix(5).map { post in
                    
                    let identifiers = post.categories.map {
                        getImageIdentifier($0)
                    }
                    
                    return Announcement(title: post.title, publishDate: post.date, imageIdentifiers: identifiers)
                }
                
                Announcement.save(announcements)
                
                if #available(iOS 14, *) {
                    DispatchQueue.main.async {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
            }
            
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
                let tryAgainLocalized = NSLocalizedString("ACTION_TRYAGAIN",
                                                          comment: "Try Again")
                let tryAgain = UIAlertAction(title: tryAgainLocalized,
                                             style: .default,
                                             handler: { _ in
                                                vc.reload(UILabel())
                                             })
                
                alert.addAction(tryAgain)
                
                alert.preferredAction = tryAgain
                
                // Open the settings app
                let settingsLocalized = NSLocalizedString("ACTION_SETTINGS",
                                                          comment: "Open Settings")
                
                alert.addAction(UIAlertAction(title: settingsLocalized,
                                              style: .default,
                                              handler: { _ in
                                                UIApplication.shared.open(GlobalLinks.settingsURL, options: [:])
                }))
                
                // Just dismiss it
                let okLocalized = NSLocalizedString("ACTION_OK",
                                                          comment: "Open Settings")

                alert.addAction(UIAlertAction(title: okLocalized, style: .cancel, handler: nil))
                
                vc.unreadPostsButton.isHidden = true
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
                
                let announcements: [Announcement] = posts.prefix(5).map { post in
                    
                    let identifiers = post.categories.map {
                        getImageIdentifier($0)
                    }
                    
                    return Announcement(title: post.title, publishDate: post.date, imageIdentifiers: identifiers)
                }
                
                Announcement.save(announcements)
                
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
    
    /// Getting image from filter
    static func getImageIdentifier(_ title: String) -> String {
        
        // Make the title lowercased to make it easier to handle
        let title = title.lowercased()
        
        // Getting image data from Icons.txt file
        let imageData = getData()
        
        // Default value, if there is no icon found use the "tag" icon
        var imageIdentifier = "tag"
        
        // Loop through dataset and associate each one with an image
        for data in imageData {
            for i in data.0 {
                if title.contains(i) {
                    // If the label contains the search terms,
                    
                    // set the image identifier and
                    imageIdentifier = data.1
                    
                    // get out of loop
                    break
                }
            }
            
            if imageIdentifier != "tag" {
                // If the image identifier is not "tag",
                // get out of the loop because it is found
                break
            }
        }
        
        return imageIdentifier
    }
    
    /// Getting image from filter
    static func getImage(_ title: String) -> UIImage {
        let imageIdentifier = getImageIdentifier(title)
        
        return UIImage(systemName: imageIdentifier) ?? UIImage(named: imageIdentifier) ?? UIImage(systemName: "tag")!
    }
    
    /// Getting data from the Icons.txt file
    static func getData() -> [([String], String)] {
        
        // Reading from Icons.txt
        do {
            let strData = try String(contentsOf: Bundle.main.url(forResource: "Icons", withExtension: "txt")!)
            
            // Spliting the data by \n
            let data = strData.split(separator: "\n")
            
            // Mapping out the data to create an array of ([String], String)
            let convertedData = data.map { value -> ([String], String) in
                let item = value.split(separator: "|")
                
                // Identifiers are the search terms used to locate the correct icon
                let identifiers: [String] = item[0].split(separator: ",").map {
                    String($0)
                }
                
                // String item[1] is the image identifier for SF Symbols
                return (identifiers, String(item[1]))
            }
            
            // Return the converted data and we're done
            return convertedData
        } catch {
            print(error.localizedDescription)
            
            return [([""], "")]
        }
    }
}
