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
        if searchField.text != "" {
            // The user is searching, sections should be based on search
            // If no results, the section count will be 0
            var sections = 0
            
            // Check if searchLabels has anything, if so, add 1
            if searchResults.labels != nil {
                sections += 1
            }
            
            // Check if search found in title has anything, if so, add 1
            if searchResults.titles != nil {
                sections += 1
            }
            
            // Check if search found in body has anything, if so, add 1
            if searchResults.contents != nil {
                sections += 1
            }
            
            return sections
        }
        
        // If posts == nil, it is loading.
        // Return 1 segment for loading animations
        if pinned.count == 0 || posts == nil || posts.count == 0 {
            return 1
        } else if pinned.count == 0 && posts.count == 0 {
            // It gave up pulling data from the feed
            // There's probably no wifi
            return 0
        }
        
        // If it is not searching, that means there will be 2 sections
        // Pinned announcements and All announcements
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the searchfield text is not empty, show search results
        if searchField.text != "" {
            // if searchterm is found in title, it appears first
            switch section {
            case 0:
                if let labels = searchResults.labels {
                    return labels.count
                    
                } else if let titles = searchResults.titles {
                    return titles.count
                    
                } else {
                    return searchResults.contents?.count ?? 0
                }
            case 1:
                if searchResults.labels != nil {
                    if let titles = searchResults.titles {
                        return titles.count
                    } else {
                        return searchResults.contents?.count ?? 0
                    }
                    
                } else {
                    return searchResults.contents?.count ?? 0
                }
            default:
                return searchResults.contents?.count ?? 0
            }
            
        } else {
            // Maximum of 5 pinned items
            if section == 0 && pinned.count != 0 {
                return pinned.count
            }
            
            // Loading screen
            if posts == nil {
                return 10
            }
            
            return posts.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: GlobalIdentifier.announcementCell,
                                                    for: indexPath) as? AnnouncementTableViewCell {
            
            let loadingString = NSLocalizedString("STATE_LOADING", comment: "Loading...")
            
            cell.parent = self
            cell.path = indexPath
            
            if posts == nil {
                // Set up loading
                setUpLoadingCell(cell, tableView: tableView)
            } else {
                if searchField.text != "" {
                    // Display Search Results
                    // Make it does not show caches
                    cell.htmlAttr = nil
                    
                    // Show search cells
                    searchingCells(cell, indexPath: indexPath)
                } else {
                    if pinned.count != 0 && indexPath.section == 0 {
                        // Pinned items
                        if pinned.count > indexPath.row {
                            cell.post = pinned[indexPath.row]
                        } else {
                            cell.post = Post(title: loadingString,
                                             content: loadingString,
                                             date: Date(),
                                             pinned: true,
                                             read: true,
                                             reminderDate: nil,
                                             categories: [])
                        }
                    } else if posts.count != 0 {
                        if posts.count > indexPath.row {
                            
                            if let cache = cachedContent[indexPath.row] {
                                cell.htmlAttr = NSMutableAttributedString(attributedString: cache)
                            }
                            
                            cell.post = posts[indexPath.row]
                            
                        } else {
                            cell.post = Post(title: loadingString, content: loadingString, date: Date(), pinned: true, read: true, reminderDate: nil, categories: [])
                            
                        }
                    }
                }
                
                if splitViewController != nil {
                    cell.highlightPost = indexPath == selectedPath
                }
                
                // Previewing
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.addInteraction(interaction)
                
                tableView.isScrollEnabled = true
                tableView.allowsSelection = true
            }
            
            return cell
        } else {
            fatalError()
        }
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When user selects row, perform segue and send the selected row's information to next VC.
        // Send the data over to the other VC
        // Deselect row after that to ensure highlighting goes away
        if let cell = tableView.cellForRow(at: indexPath) as? AnnouncementTableViewCell {
            
            selectedItem = cell.post
            
            // Highlight post if it should be highlighted
            // On start, it would be the first cell
            // Otherwise, it is whatever cell is previously highlighted
            cell.highlightPost = indexPath == selectedPath
            
            if I.phone {
                // Deselect the row so as to avoid weird animation issues
                tableView.deselectRow(at: indexPath, animated: false)
            }
            
            // Appending posts to read posts
            // - Getting read announcements from file
            var readAnnouncements = ReadAnnouncements.loadFromFile() ?? []
            
            // - Adding the read announcement to the new array
            readAnnouncements.append(cell.post)
            
            // - Save announcements to file
            ReadAnnouncements.saveToFile(posts: readAnnouncements)
            
            // Updating and going to contentVC
            if let splitVC = splitViewController as? SplitViewController {
                // Get contentVC from splitVC
                let contentVC = splitVC.contentVC
                
                // Getting the post from cell and setting it in the ContentVC
                contentVC.post = cell.post
                
                // Getting the attributedContent from the cell and set it in contentVC
                contentVC.attributedContent = cell.htmlAttr
                
                // Unhighlight previous cell
                if let previousCell = tableView.cellForRow(at: selectedPath) as? AnnouncementTableViewCell {
                    previousCell.highlightPost = false
                }
                
                // Highlight current cell
                cell.highlightPost = true
                
                // Setting the current cell's indexPath to be selectedPath so that it can be used as previousCell
                selectedPath = indexPath
                
                // Update the Cell's UI based on whether it is read or unread
                cell.handlePinAndRead()
            } else {
                // Get contentVC
                let contentVC = getContentViewController(for: indexPath)
                
                // Getting the attributedContent from the cell and set it in contentVC
                contentVC.attributedContent = cell.htmlAttr
                
                // Present contentVC via navigation controller
                navigationController?.pushViewController(contentVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headers = [NSLocalizedString("CATEGORIES_PINNED",
                                         comment: "Pinned"),
                       NSLocalizedString("CATEGORIES_ALL",
                                         comment: "All Announcements")]
        if pinned.count == 0 {
            headers = [NSLocalizedString("CATEGORIES_ALL",
                                         comment: "All Announcements")]
        }
        
        if searchField.text != "" {
            headers = []
            
            if searchResults.labels != nil {
                headers.append(NSLocalizedString("POST_LABELS",
                                                 comment: "Labels"))
            }
            if searchResults.titles != nil {
                headers.append(NSLocalizedString("POST_TITLE",
                                                 comment: "Title"))
            }
            if searchResults.contents != nil {
                headers.append(NSLocalizedString("POST_CONTENT",
                                                 comment: "Content"))
            }
        }
        
        if section > headers.count - 1 {
            return ""
        }
        
        return headers[section]
    }
    
    //Swipe <-
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [pinPost(forRowAtIndexPath: indexPath)])
        return swipeConfig
    }
    
    // MARK: - Swipe Function Handlers
    //Pin Handlers
    func pinPost(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        // Register the cell
        
        guard let cell = announcementTableView.cellForRow(at: indexPath) as? AnnouncementTableViewCell else {
            fatalError()
        }
        
        let post = cell.post!
        
        let pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        
        var title = String()
        
        //If is in pinnned
        if pinnedItems.contains(post) {
            //Unpin post
            title = NSLocalizedString("POST_UNPIN",
                                      comment: "Unpin")
        } else {
            //Pin post
            title = NSLocalizedString("POST_PIN",
                                      comment: "Pin")
        }
        
        //Action Builder
        let action = UIContextualAction(style: .normal,
                                        title: title) { (_: UIContextualAction,
                                                         _: UIView,
                                                         completionHandler: (Bool) -> Void) in
            
            //Toggle pin based on context
            if title == NSLocalizedString("POST_UNPIN",
                                          comment: "Unpin") {
                var pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
                
                pinnedItems.remove(at: pinnedItems.firstIndex(of: post)!)
                
                PinnedAnnouncements.saveToFile(posts: pinnedItems)
            } else {
                var pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
                
                pinnedItems.append(post)
                
                PinnedAnnouncements.saveToFile(posts: pinnedItems)
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                self.pinned = PinnedAnnouncements.loadFromFile() ?? []
                
                print("Pinnned")
                self.announcementTableView.reloadData()
                
                // Getting the post from cell and setting it in the ContentVC
                if let splitVC = self.splitViewController as? SplitViewController {
                    splitVC.contentVC.updatePinned()
                }
            }
            
            //Complete
            completionHandler(true)
        }
        action.backgroundColor = GlobalColors.greyTwo
        return action
    }
}
