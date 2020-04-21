//
//  Labels.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import SystemConfiguration
import UserNotifications
import UIKit
import BackgroundTasks

// Blog URL
// should be http://studentsblog.sst.edu.sg unless testing
// Test blog https://testannouncer.blogspot.com
let blogURL = "http://studentsblog.sst.edu.sg"

// RSS URL
let rssURL = URL(string: "\(blogURL)/feeds/posts/default")!

// JSON Callback URL
// Returns back the Labels for sorting
// http://studentsblog.sst.edu.sg/feeds/posts/summary?alt=json&max-results=0&callback=cat
let jsonCallback = URL(string: "\(blogURL)/feeds/posts/summary?alt=json&max-results")!

var filter = ""

// Struct that contains the date, content and title of each post
struct Post: Codable, Equatable {
    var title: String
    var content: String // This content will be a HTML as a String
    var date: Date
    
    var pinned: Bool
    var read: Bool
    var reminderDate: Date?
    
    var categories: [String]
}

// JSON Callback to get all the labels for the blog posts
func fetchLabels() -> [String] {
    
    let parser = FeedParser(URL: rssURL)
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

func fetchBlogPosts(_ vc: AnnouncementsViewController) -> [Post] {
    let parser = FeedParser(URL: rssURL)
    let result = parser.parse()
    
    switch result {
    case .success(let feed):
        let feed = feed.atomFeed
        let posts = convertFromEntries(feed: (feed?.entries!)!)
        
        UserDefaults.standard.set(posts[0].title, forKey: "recent-title")
        UserDefaults.standard.set(posts[0].content, forKey: "recent-content")
        
        return posts
    case .failure(let error):
        print(error.localizedDescription)
        // Present alert
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Uh Oh :(", message: "Slow or no internet connection.\nPlease check your settings and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                vc.reload(UILabel())
            }))
            
            alert.addAction(UIAlertAction(title: "Open in Settings", style: .default, handler: { action in
                let url = URL(string: "App-Prefs:root=")!
                UIApplication.shared.open(url, options: [:]) { (success) in
                    print(success)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                
            }))
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    return []
}

func fetchNotificationsTitle() -> (title: String, content: String)? {
    let parser = FeedParser(URL: rssURL)
    let result = parser.parse()
    
    switch result {
    case .success(let feed):
        let feed = feed.atomFeed
        
        let posts = convertFromEntries(feed: (feed?.entries)!)
        
        if posts[0].title != UserDefaults.standard.string(forKey: "recent-title") && posts[0].content != UserDefaults.standard.string(forKey: "recent-content") {
            
            UserDefaults.standard.set(posts[0].title, forKey: "recent-title")
            UserDefaults.standard.set(posts[0].content, forKey: "recent-content")
            
            return (title: convertFromEntries(feed: (feed?.entries!)!).first!.title, content: convertFromEntries(feed: (feed?.entries!)!).first!.content.htmlToString)
        }
        
    default:
        break
    }
    
    return nil
}


// Convert Enteries to Posts
func convertFromEntries(feed: [AtomFeedEntry]) -> [Post] {
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

func getTagsFromSearch(with query: String) -> String {
    // Tags in search are a mess to deal with
    if query.first == "[" {
        let split = query.split(separator: "]")
        var result = split[0]
        result.removeFirst()
        
        return String(result.lowercased())
    }
    return ""
}

func getShareURL(with post: Post) -> URL {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "/yyyy/MM/"
    
    //We share url not text because text is stupid
    var shareLink = ""
    
    let formatted = post.title.filter { (a) -> Bool in
        a.isLetter || a.isNumber || a.isWhitespace
    }.lowercased()
    let split = formatted.split(separator: " ")
    
    for i in split {
        if shareLink.count + i.count < 40 {
            shareLink += i + "-"
        } else {
            break
        }
    }
    shareLink.removeLast()
    
    // 40 chars
    shareLink = blogURL + dateFormatter.string(from: post.date) + shareLink + ".html"
    
    return URL(string: shareLink) ?? URL(string: blogURL)!
}
