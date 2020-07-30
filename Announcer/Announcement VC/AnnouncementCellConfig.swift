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
    
    func searchingCells(_ cell: AnnouncementTableViewCell, indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if searchLabels.count > 0 {
                updateSearch(with: searchLabels, cell: cell, path: indexPath)
            } else if searchFoundInTitle.count >= 0 {
                updateSearch(with: searchFoundInTitle, cell: cell, path: indexPath)
            } else {
                updateSearch(with: searchFoundInBody, cell: cell, path: indexPath)
            }
        case 1:
            if searchLabels.count > 0 {
                if searchFoundInTitle.count >= 0 {
                    updateSearch(with: searchFoundInTitle, cell: cell, path: indexPath)
                } else {
                    updateSearch(with: searchFoundInBody, cell: cell, path: indexPath)
                }
            } else {
                updateSearch(with: searchFoundInBody, cell: cell, path: indexPath)
            }
        default:
            updateSearch(with: searchFoundInBody, cell: cell, path: indexPath)
        }
    }
}
