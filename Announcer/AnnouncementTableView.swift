//
//  AnnouncementTableView.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension AnnouncementsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    #warning("haven't gotten around to fixing pinned items")
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts == nil {
            return 10
        }
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "announcements", for: indexPath) as! AnnouncementTableViewCell
        
        if posts == nil {
            cell.startLoader()
        } else {
            cell.post = posts[indexPath.row]
        }
        return cell
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When user selects row, perform segue and send the selected row's information to next VC.
        // Send the data over to the other VC
        // Deselect row after that to ensure highlighting goes away
        let cell = tableView.cellForRow(at: indexPath) as! AnnouncementTableViewCell
        
        selectedItem = cell.post
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "showContent", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headers = ["Pinned", "All Announcements"]
        return headers[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !searchField.isFirstResponder {
            if scrollView.contentOffset.y <= -150 {
                let offset = (scrollView.contentOffset.y * -1 - 100) / 100
                filterButton.alpha = 1 - offset
                searchField.alpha = 1
            } else if scrollView.contentOffset.y <= -50 {
                filterButton.alpha = 1
                let offset = (scrollView.contentOffset.y * -1 - 50) / 100
                searchField.alpha = 1 - offset
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= -150 {
            print("Search Bar")
            sortWithLabels(UILabel())
        } else if scrollView.contentOffset.y <= -50 {
            print("Filter Button")
            searchField.becomeFirstResponder()
        }
        filterButton.alpha = 1
        searchField.alpha = 1
    }
}
