//
//  AnnouncementSearchBar.swift
//  Announcer
//
//  Created by JiaChen(: on 28/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import UIKit

// Set up everything related to search bar here
extension AnnouncementsViewController: UISearchBarDelegate {
    // When user presses "Search", dismiss keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    // When text changes, update search results with searchText
    // Seach results automatically reloads when value changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Handling when posts are missing because reloading
        if posts == nil { return }
        
        if let searchQueue = searchQueue {
            searchQueue.cancel()
        }
        
        // It takes a bit to search so just run it in the background
        searchQueue = DispatchWorkItem(qos: .userInteractive, flags: .assignCurrentContext) {
            // Set color of labels
            // Update labels/textview with data
            let attrTitle = NSMutableAttributedString(string: searchText)
            // Find the [] and just make it like Grey 2
            
            let font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
            
            // Set default attributes
            let defaultAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label,
                                                                    .font: font]
            
            attrTitle.addAttributes(defaultAttributes, range: NSRange(location: 0, length: attrTitle.string.count))
            
            // Get search field
            let field = searchBar.value(forKey: "searchField") as? UITextField
            
            let regexBracket = try! NSRegularExpression(pattern: GlobalIdentifier.regexSquarePattern)
            
            if let match = regexBracket.firstMatch(in: searchText,
                                                   options: [],
                                                   range: NSRange(location: 0, length: searchText.count)) {
                
                let font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
                
                // Setting font color and font
                let bracketStyle: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "Text Blue")!,
                                                                   .font: font]
                
                // Add attributes
                attrTitle.addAttributes(bracketStyle,
                                        range: match.range)
            }
            
            DispatchQueue.main.async {
                // Add attributes to field
                field?.attributedText = attrTitle
            }
            
            self.searchResults = AnnouncementSearch(labelsDidSet: {
                self.updateFilterButton()
            })
            
            // Update content
            self.searchResults.titles = self.getSearchTitlePosts(searchText)
            
            self.searchResults.contents = self.getSearchContentPosts(searchText)
            
            self.searchResults.labels = self.getSearchTagPosts(searchText)
            
            // Escape to main thread to update tableView
            DispatchQueue.main.async {
                // Reload tableView's data
                self.announcementTableView.reloadData()
            }
        }
        
        if let searchQueue = searchQueue {
            DispatchQueue.global().async(execute: searchQueue)
        }
    }
    
    struct SearchItem {
        var post: Post
        var relevance: Double
    }
    
    func getSearchTitlePosts(_ searchText: String) -> [Post]? {
        let mainQuery = searchText.lowercased().filter({
            $0.isNumber || $0.isLetter
        })
        
        let queries = mainQuery.split(separator: " ")
        
        let titlePosts: [Post] = self.posts.map { (postItem) -> SearchItem in
            
            // Calculating relevance
            let postTitle = postItem.title.lowercased().filter({
                $0.isNumber || $0.isLetter
            })
            
            // - Calculating the match score
            var counts = 0
            var rawMatchScore = 0.0
            var matches = 0
            
            //    - Count complete matches, where the string is exactly in there
            let completeMatches = postTitle.indicesOf(string: mainQuery).count
            
            counts += completeMatches * 2
            rawMatchScore += Double(completeMatches)
            
            //    - Looping through queries to get the indices
            for query in queries {
                let partialMatches = postTitle.indicesOf(string: String(query)).count
                
                counts += partialMatches
                matches += partialMatches == 0 ? 0 : 1
                rawMatchScore += Double(partialMatches) * 0.5
            }
            
            let uniqueMatchPercentage: Double = Double(matches) / Double(queries.count)
            let matchScore: Double = (rawMatchScore / Double(counts * 2)) * uniqueMatchPercentage
            
            // - Calculating the time score
            let timeScore: Double = 1 / (abs(postItem.date.timeIntervalSinceNow) / 86400 + 1)
            
            return SearchItem(post: postItem, relevance: timeScore * matchScore)
        }.filter {
            $0.relevance > 0
        }.sorted {
            $0.relevance > $1.relevance
        }.map {
            $0.post
        }
        
        return titlePosts.count == 0 ? nil : titlePosts
    }
    
    func getSearchContentPosts(_ searchText: String) -> [Post]? {
        let mainQuery = searchText.lowercased().filter({
            $0.isNumber || $0.isLetter
        })
        
        let queries = mainQuery.split(separator: " ")
        
        // swiftlint:disable identifier_name
        let contentPosts: [Post] = self.posts.map { postItem -> SearchItem in
            // Calculating relevance
            
            var postContent: String = cachedContent[postItem.title]??.string ?? postItem.content.htmlToAttributedString!.string
            
            postContent = postContent.lowercased().filter({
                $0.isNumber || $0.isLetter
            })
            
            // - Calculating the match score
            var counts = 0
            var rawMatchScore = 0.0
            var matches = 0
            
            //    - Count complete matches, where the string is exactly in there
            let completeMatches = postContent.indicesOf(string: mainQuery).count
            
            counts += completeMatches
            rawMatchScore += Double(completeMatches)
            
            //    - Looping through queries to get the indices
            for query in queries {
                let partialMatches = postContent.indicesOf(string: String(query)).count
                
                counts += partialMatches
                matches += partialMatches == 0 ? 0 : 1
                rawMatchScore += Double(partialMatches) * 0.5
            }
            
            let uniqueMatchPercentage: Double = Double(matches) / Double(queries.count)
            
            let matchScore: Double = (rawMatchScore / Double(counts * 4)) * uniqueMatchPercentage
            
            // - Calculating the time score
            let timeScore: Double = 1 / (abs(postItem.date.timeIntervalSinceNow) / 86400 + 1)
            
            return SearchItem(post: postItem, relevance: timeScore * matchScore)
            
        }.filter {
            $0.relevance > 0
        }.sorted {
            $0.relevance > $1.relevance
        }.map {
            $0.post
        }
        
        return contentPosts.count == 0 ? nil : contentPosts
    }
    
    func getSearchTagPosts(_ searchText: String) -> [Post]? {
        let query = getLabelsFromSearch(with: searchText).lowercased()
        
        let contentPosts: [Post] = self.posts.filter {
            $0.categories.map({
                $0.lowercased()
            }).contains(query)
        }.sorted {
            let firstTime: Double = 1 / (abs($0.date.timeIntervalSinceNow) / 86400 + 1)
            let secondTime: Double = 1 / (abs($1.date.timeIntervalSinceNow) / 86400 + 1)
            
            return firstTime > secondTime
        }
        
        return contentPosts.count == 0 ? nil : contentPosts
    }
}
