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
        
        // It takes a bit to search so just run it in the background
        DispatchQueue.global(qos: .background).async {
            // Set color of labels
            // Update labels/textview with data
            let attrTitle = NSMutableAttributedString(string: searchText)
            // Find the [] and just make it like Grey 2
            
            // Make square brackets colored
            let indicesStart = attrTitle.string.indicesOf(string: "[")
            let indicesEnd = attrTitle.string.indicesOf(string: "]")
            
            // Set default attributes
            let defaultAttributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)]
            
            attrTitle.addAttributes(defaultAttributes, range: NSRange(location: 0, length: attrTitle.string.count))
            
            // Get search field
            let field = searchBar.value(forKey: "searchField") as? UITextField
            
            if indicesStart.count == 1 && indicesEnd.count == 1 {
                
                // Determine which one is smaller (start indices or end indices)
                if (indicesStart.count <= (indicesEnd.count) ? indicesStart.count : indicesEnd.count) > 0 {
                    for i in 1...(indicesStart.count >= indicesEnd.count ? indicesStart.count : indicesEnd.count) {
                        
                        let start = indicesStart[i - 1]
                        let end = indicesEnd[i - 1]
                        
                        // [] colors will be Grey 1
                        // @shannen why these color names man
                        
                        let bracketStyle : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)]
                        
                        attrTitle.addAttributes(bracketStyle, range: NSRange(location: start, length: end - start + 1))
                    }
                }
            }
            
            DispatchQueue.main.async {
                field?.attributedText = attrTitle
            }
            
            // Update content
            self.searchFoundInTitle = self.posts.filter { (post) -> Bool in
                let newTitle = post.title.removeWhitespace().lowercased().removeLabel()
                
                if newTitle.contains(searchText.removeWhitespace().lowercased()) {
                    return true
                }
                return false
            }
            
            self.searchFoundInBody = self.posts.filter { (post) -> Bool in
                let newContent = post.content.removeWhitespace().lowercased().removeLabel()
                
                if newContent.contains(searchText.removeWhitespace().lowercased()) {
                    return true
                }
                return false
            }
            
            self.searchLabels = self.posts.filter({ (post) -> Bool in
                let label = getLabelsFromSearch(with: searchText)
                
                let newCat = post.categories.map { (str) -> String in
                    str.lowercased()
                }
                
                return newCat.contains(label)
            })
            
            DispatchQueue.main.async {
                self.announcementTableView.reloadData()
            }
        }
    }
}
