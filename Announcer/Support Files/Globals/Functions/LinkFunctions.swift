//
//  LinkFunctions.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

struct LinkFunctions {
    /**
     Gets the share URL from a `Post`
     
     - returns: The URL of the blog post
     
     - parameters:
        - post: The post to be shared
      
     - important: This method handles error 404 by simply returning the `blogURL`
     
     - note: Versions of SST Announcer before 11.0 shared the full content of the post instead of the URL
     
     This method generates a URL for the post by merging the date and the post title.
    */
    static func getShareURL(with post: Post) -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "/yyyy/MM/"
        
        var shareLink = ""
        
        let formatted = post.title.filter { (char) -> Bool in
            char.isLetter || char.isNumber || char.isWhitespace
        }.lowercased()
        let split = formatted.split(separator: " ")
        
        // Add "-" between words. Ensure that it is under 45 characters, because blogger.
        for i in split {
            if shareLink.count + i.count < 45 {
                shareLink += i + "-"
            } else {
                break
            }
        }
        
        shareLink.removeLast()
        
        shareLink = GlobalLinks.blogURL + dateFormatter.string(from: post.date) + shareLink + ".html"
        
        let shareURL = URL(string: shareLink) ?? URL(string: GlobalLinks.blogURL)!
        
        // Checking if the URL brings up a 404 page
        let isURLValid: Bool = {
            let str = try? String(contentsOf: shareURL)
            if let str = str {
                return !str.contains("Sorry, the page you were looking for in this blog does not exist.")
            } else {
                return false
            }
        }()
        
        if isURLValid {
            return shareURL
        }
        
        return URL(string: GlobalLinks.blogURL)!
    }

    /**
     Gets the links within the `Post`
     
     - returns: An array of `URL`s which are in the post.
     
     - parameters:
        - post: The selected post
     
     - important: This process takes a bit so it is better to do it
     asyncronously so the app will not freeze while searching for URLs.
     
     This method gets the URLs found within the blog post and filters
     out images from blogger's content delivery network because no one wants those URLs.
    */
    static func getLinksFromPost(post: Post) -> [URL] {
        let items = post.content.components(separatedBy: "href=\"")
        
        var links: [URL] = []
        
        for item in items {
            var newItem = ""
            
            for character in item {
                if character != "\"" {
                    newItem += String(character)
                } else {
                    break
                }
            }
            
            if let url = URL(string: newItem) {
                links.append(url)
            }
        }
        
        links.removeDuplicates()
        
        links = links.filter { (link) -> Bool in
            !link.absoluteString.contains("bp.blogspot.com/")
        }
        
        return links
    }
}
