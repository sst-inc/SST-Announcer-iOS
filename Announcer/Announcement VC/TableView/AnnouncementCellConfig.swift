//
//  AnnouncementCellConfig.swift
//  Announcer
//
//  Created by JiaChen(: on 30/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension AnnouncementsViewController {
    func setUpLoadingCell(_ cell: AnnouncementTableViewCell, tableView: UITableView) {
        // Handles when posts do not exist aka it is loading or no internet
        
        // Start loading indicator (the fancy animations over the content)
        cell.startLoader()
        
        // When loading, disable interactivity with tableView
        // Therefore, disable scrolling and selecting
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }
    
    // Function to update the search results while ensuring it does not crash
    func updateSearch(with searchSource: [Post], cell: AnnouncementTableViewCell, path indexPath: IndexPath) {
        
//        if (searchResults.titles?.count ?? 0) - 1 >= indexPath.row {
//            cell.post = searchResults.titles?[indexPath.row]
//        }
        
        cell.post = searchSource[indexPath.row]
    }
    
    func searchingCells(_ cell: AnnouncementTableViewCell, indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let labels = searchResults.labels {
                updateSearch(with: labels, cell: cell, path: indexPath)
                
            } else if let titles = searchResults.titles {
                updateSearch(with: titles, cell: cell, path: indexPath)
                
            } else if let content = searchResults.contents {
                updateSearch(with: content, cell: cell, path: indexPath)
                
            }
        case 1:
            if searchResults.labels != nil {
                
                if let titles = searchResults.titles {
                    updateSearch(with: titles, cell: cell, path: indexPath)
                    
                } else if let contents = searchResults.contents {
                    updateSearch(with: contents, cell: cell, path: indexPath)
                    
                }
                
            } else if let contents = searchResults.contents {
                updateSearch(with: contents, cell: cell, path: indexPath)
                
            }
        default:
            if let contents = searchResults.contents {
                updateSearch(with: contents, cell: cell, path: indexPath)
                
            }
        }
    }
}
