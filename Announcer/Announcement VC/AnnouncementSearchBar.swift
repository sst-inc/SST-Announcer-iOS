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
        searchFoundInTitle = posts.filter { (post) -> Bool in
            let newTitle = post.title.removeWhitespace().lowercased()
            
            if newTitle.contains(searchText.removeWhitespace().lowercased()) {
                return true
            }
            return false
        }
        
        searchFoundInBody = posts.filter { (post) -> Bool in
            let newContent = post.content.removeWhitespace().lowercased()
            
            if newContent.contains(searchText.removeWhitespace().lowercased()) {
                return true
            }
            return false
        }
        
        announcementTableView.reloadData()
    }
}
