//
//  Labels.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import SystemConfiguration
import UserNotifications

// Blog URL
// should be https://studentsblog.sst.edu.sg unless testing
#warning("Make sure the blog URL is correct on launch")
let blogURL = "http://studentsblog.sst.edu.sg"

// RSS URL
let rssURL = URL(string: "\(blogURL)/feeds/posts/default")!

// JSON Callback URL
// http://studentsblog.sst.edu.sg/feeds/posts/summary?alt=json&max-results=0&callback=cat
let jsonCallback = URL(string: "\(blogURL)/feeds/posts/summary?alt=json&max-results")!

var filter = ""

// Struct that contains the date, content and title of each post
struct Post: Codable {
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
    var labels = [String]()
    
    do {
        let strData = try String(contentsOf: jsonCallback)
        let split = strData.split(separator: ",")
        let filtered = split.filter { (value) -> Bool in
            
            return value.contains("term")
        }
        
        for item in filtered {
            labels.append(String(item).replacingOccurrences(of: "{\"term\":\"", with: "").replacingOccurrences(of: "\"}", with: "").replacingOccurrences(of: "\\u0026", with: "\u{0026}"))
        }
        labels[0].removeFirst("\"category\":[".count)
        labels[labels.count - 1].removeLast()
    } catch {
        print(error.localizedDescription)
    }
    
    return labels
}

func fetchBlogPosts() -> [Post] {
    let parser = FeedParser(URL: rssURL)
    let result = parser.parse()
    
    switch result {
    case .success(let feed):
        print(feed)
        let feed = feed.atomFeed
        
        return convertFromEntries(feed: (feed?.entries!)!)
    case .failure(let error):
        print(error.localizedDescription)
    }
    
    return []
}

// Convert Enteries to Posts
func convertFromEntries(feed: [AtomFeedEntry]) -> [Post] {
    var posts = [Post]()
    for entry in feed {
        let cat = entry.categories ?? []
        
        posts.append(Post(title: entry.title!,
                          content: (entry.content?.value)!,
                          date: entry.published!,
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

// For displaying data previews and displaying full screen
extension String {
    var htmlToAttributedString: NSMutableAttributedString? {
        do {
            return try NSMutableAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    
    func removeWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
