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
            if searchLabels.count > 0 {
                sections += 1
            }
            
            // Check if search found in title has anything, if so, add 1
            if searchFoundInTitle.count > 0 {
                sections += 1
            }
            
            // Check if search found in body has anything, if so, add 1
            if searchFoundInBody.count > 0 {
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
                if searchLabels.count > 0 {
                    return searchLabels.count
                } else if searchFoundInTitle.count >= 0 {
                    return searchFoundInTitle.count
                } else {
                    return searchFoundInBody.count
                }
            case 1:
                if searchLabels.count > 0 {
                    if searchFoundInTitle.count >= 0 {
                        return searchFoundInTitle.count
                    } else {
                        return searchFoundInBody.count
                    }
                } else {
                    return searchFoundInBody.count
                }
            default:
                return searchFoundInBody.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GlobalIdentifier.announcementCell, for: indexPath) as! AnnouncementTableViewCell
        
        if posts == nil {
            // Handles when posts do not exist aka it is loading or no internet
            
            // Start loading indicator (the fancy animations over the content)
            cell.startLoader()
            
            // When loading, disable interactivity with tableView
            // Therefore, disable scrolling and selecting
            tableView.isScrollEnabled = false
            tableView.allowsSelection = false
        } else {
            if searchField.text != "" {
                // Display Search Results
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
                
            } else {
                if pinned.count != 0 && indexPath.section == 0 {
                    // Pinned items
                    if pinned.count > indexPath.row {
                        cell.post = pinned[indexPath.row]
                    } else {
                        cell.post = Post(title: "Loading...",
                                         content: "Loading...",
                                         date: Date(),
                                         pinned: true,
                                         read: true,
                                         reminderDate: nil,
                                         categories: [])
                    }
                } else if posts.count != 0  {
                    if posts.count > indexPath.row {
                        cell.post = posts[indexPath.row]
                    } else {
                        cell.post = Post(title: "Loading...",
                                         content: "Loading...",
                                         date: Date(),
                                         pinned: true,
                                         read: true,
                                         reminderDate: nil,
                                         categories: [])
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
    }
    
    // Function to update the search results while ensuring it does not crash
    func updateSearch(with searchSource: [Post], cell: AnnouncementTableViewCell, path indexPath: IndexPath) {
        if searchFoundInTitle.count - 1 >= indexPath.row {
            cell.post = searchFoundInTitle[indexPath.row]
        }
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When user selects row, perform segue and send the selected row's information to next VC.
        // Send the data over to the other VC
        // Deselect row after that to ensure highlighting goes away
        let cell = tableView.cellForRow(at: indexPath) as! AnnouncementTableViewCell
        
        selectedItem = cell.post
        
        // Highlight post if it should be highlighted
        // On start, it would be the first cell
        // Otherwise, it is whatever cell is previously highlighted
        cell.highlightPost = indexPath == selectedPath
        
        // Deselect the row so as to avoid weird animation issues
        tableView.deselectRow(at: indexPath, animated: false)
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headers = ["Pinned", "All Announcements"]
        if pinned.count == 0 {
            headers = ["All Announcements"]
        }
        
        if searchField.text != "" {
            headers = []
            
            if searchLabels.count > 0 {
                headers.append("Labels")
            }
            if searchFoundInTitle.count > 0 {
                headers.append("Title")
            }
            if searchFoundInBody.count > 0 {
                headers.append("Content")
            }
            
        }
        
        return headers[section]
    }
    
    //Swipe <-
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [pinPost(forRowAtIndexPath: indexPath)])
        return swipeConfig
    }
    
    // MARK: - Swipe Function Handlers
    //Pin Handlers
    func pinPost(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        // Register the cell
        let cell = announcementTableView.cellForRow(at: indexPath) as! AnnouncementTableViewCell
        
        let pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        
        let post = cell.post!
        
        var title = String()
        
        //If is in pinnned
        if pinnedItems.contains(post) {
            //Unpin post
            title = "Unpin"
        } else {
            //Pin post
            title = "Pin"
        }
        
        //Action Builder
        let action = UIContextualAction(style: .normal, title: title) { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            
            //Toggle pin based on context
            if title == "Unpin" {
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
    
    
    // MARK: ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if I.wantToBeMac || I.mac {
            // Dismiss keyboard at for iPads because they do not auto dismiss
            view.endEditing(true)
        }
        
//        if scrollView.contentOffset.y > 5 {
//            UIView.animate(withDuration: 0.5) {
//                self.searchHeightConstraint.constant = 0
//                self.searchStackView.translatesAutoresizingMaskIntoConstraints = false
//            }
//            
//        } else {
//            UIView.animate(withDuration: 0.5) {
//                self.searchHeightConstraint.constant = 56
//                self.searchStackView.translatesAutoresizingMaskIntoConstraints = false
//            }
//            
//        }
        
        if !searchField.isFirstResponder && !UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.scrollSelection.rawValue) && !I.mac {
            if scrollView.contentOffset.y <= -3 * scrollSelectionMultiplier {
                
                ScrollSelection.setNormalState(for: filterButton)
                ScrollSelection.setNormalState(for: searchField)
                
                ScrollSelection.setSelectedState(barButton: reloadButton!,
                                                 withOffset: scrollView.contentOffset.y,
                                                 andConstant: 3 * scrollSelectionMultiplier)
                
                if playedHaptic != 1 {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                }
                playedHaptic = 1
            } else if scrollView.contentOffset.y <= -2 * scrollSelectionMultiplier {
                ScrollSelection.setNormalState(for: searchField)
                ScrollSelection.setNormalState(barButton: reloadButton)
                
                ScrollSelection.setSelectedState(for: filterButton,
                                                 withOffset: scrollView.contentOffset.y,
                                                 andConstant: 2 * scrollSelectionMultiplier)
                
                if playedHaptic != 2 {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }
                
                playedHaptic = 2
            } else if scrollView.contentOffset.y <= -1 * scrollSelectionMultiplier {
                
                ScrollSelection.setNormalState(for: filterButton)
                ScrollSelection.setNormalState(barButton: reloadButton)
                
                ScrollSelection.setSelectedState(for: searchField,
                                                 withOffset: scrollView.contentOffset.y,
                                                 andConstant: scrollSelectionMultiplier)
                
                if playedHaptic != 3 {
                    
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
                playedHaptic = 3
            } else {
                resetScroll()
                playedHaptic = 0
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        #if targetEnvironment(macCatalyst)
        // Disabled scroll selection on mac catalyst
        #else
            if !UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.scrollSelection.rawValue) {
                resetScroll()
                if scrollView.contentOffset.y <= -3 * scrollSelectionMultiplier {
                    // Reload view
                    reload(UILabel())
                    
                } else if scrollView.contentOffset.y <= -2 * scrollSelectionMultiplier {
                    // Show labels selection screen
                    sortWithLabels(UILabel())
                    
                } else if scrollView.contentOffset.y <= -1 * scrollSelectionMultiplier {
                    if I.wantToBeMac || I.mac {
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                            // Select search field
                            self.searchField.becomeFirstResponder()
                            
                            // Reset search field style
                            ScrollSelection.setNormalState(for: self.searchField)
                        }
                    } else {
                        // Select search field
                        searchField.becomeFirstResponder()
                        
                        // Reset search field style
                        ScrollSelection.setNormalState(for: searchField)
                    }
                }
                
                filterButton.tintColor = GlobalColors.greyOne
                searchField.alpha = 1
                reloadButton.tintColor = GlobalColors.greyOne
                
                resetScroll()
            }
        #endif
    }
    
    func resetScroll() {
        filterButton.layer.borderWidth = 0
        searchField.getTextField()?.layer.borderWidth = 0
        reloadButton.tintColor = GlobalColors.greyOne
    }
}
