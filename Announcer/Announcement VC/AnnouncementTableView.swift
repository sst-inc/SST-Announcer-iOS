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
            
            // Check if searchTags has anything, if so, add 1
            if searchTags.count > 0 {
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the searchfield text is not empty, show search results
        if searchField.text != "" {
            // if searchterm is found in title, it appears first
            switch section {
            case 0:
                if searchTags.count > 0 {
                    return searchTags.count
                } else if searchFoundInTitle.count >= 0 {
                    return searchFoundInTitle.count
                } else {
                    return searchFoundInBody.count
                }
            case 1:
                if searchTags.count > 0 {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "announcements", for: indexPath) as! AnnouncementTableViewCell
        
        if posts == nil {
            cell.startLoader()
            tableView.isScrollEnabled = false
            tableView.allowsSelection = false
        } else {
            if searchField.text != "" {
                // Display Search Results
                switch indexPath.section {
                case 0:
                    if searchTags.count > 0 {
                        cell.post = searchTags[indexPath.row]
                    } else if searchFoundInTitle.count >= 0 {
                        cell.post = searchFoundInTitle[indexPath.row]
                    } else {
                        cell.post = searchFoundInBody[indexPath.row]
                    }
                case 1:
                    if searchTags.count > 0 {
                        if searchFoundInTitle.count >= 0 {
                            cell.post = searchFoundInTitle[indexPath.row]
                        } else {
                            cell.post = searchFoundInBody[indexPath.row]
                        }
                    } else {
                        cell.post = searchFoundInBody[indexPath.row]
                    }
                default:
                    cell.post = searchFoundInBody[indexPath.row]
                }
                
            } else {
                if pinned.count != 0 && indexPath.section == 0 {
                    cell.post = pinned[indexPath.row]
                } else if posts.count != 0  {
                    cell.post = posts[indexPath.row]
                }
            }
            
            if #available(iOS 13.0, *) {
                let interaction = UIContextMenuInteraction(delegate: self)
                cell.addInteraction(interaction)
            }
            
            tableView.isScrollEnabled = true
            tableView.allowsSelection = true
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
        
        // Appending posts to read posts
        var readAnnouncements = ReadAnnouncements.loadFromFile() ?? []
        readAnnouncements.append(cell.post)
        ReadAnnouncements.saveToFile(posts: readAnnouncements)
        
        let vc = getContentViewController(for: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headers = ["Pinned", "All Announcements"]
        if pinned.count == 0 {
            headers = ["All Announcements"]
        }
        
        if searchField.text != "" {
            headers = []
            
            if searchTags.count > 0 {
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
    
    //Swipe Function Handlers
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
            }
            
            //Complete
            completionHandler(true)
        }
        action.backgroundColor = UIColor(named: "Guan Yellow")
        return action
    }
    
    
    // MARK: ScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if #available(iOS 13.0, *) {
            #if targetEnvironment(macCatalyst)
            #else
            if !searchField.isFirstResponder && !UserDefaults.standard.bool(forKey: "scrollSelection") {
                if scrollView.contentOffset.y <= -150 {
                    let offset = (scrollView.contentOffset.y * -1 - 150) / 100
                    filterButton.layer.borderWidth = 0
                    filterButton.layer.borderColor = borderColor
                    
                    searchField.getTextField()?.layer.borderWidth = 0
                    searchField.getTextField()?.layer.borderColor = borderColor
                    reloadButton.layer.borderWidth = 25 * offset
                    reloadButton.layer.borderColor = borderColor
                    
                    if playedHaptic != 1 {
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                    }
                    playedHaptic = 1
                } else if scrollView.contentOffset.y <= -100 {
                    let offset = (scrollView.contentOffset.y * -1 - 100) / 100
                    filterButton.layer.borderWidth = 25 * offset
                    filterButton.layer.borderColor = borderColor
                    
                    searchField.getTextField()?.layer.borderWidth = 0
                    searchField.getTextField()?.layer.borderColor = borderColor
                    reloadButton.layer.borderWidth = 0
                    reloadButton.layer.borderColor = borderColor
                    
                    if playedHaptic != 2 {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                    playedHaptic = 2
                } else if scrollView.contentOffset.y <= -50 {
                    filterButton.layer.borderWidth = 0
                    filterButton.layer.borderColor = borderColor
                    
                    let offset = (scrollView.contentOffset.y * -1 - 50) / 100
                    searchField.getTextField()?.layer.borderWidth = 40 * offset
                    searchField.getTextField()?.clipsToBounds = false
                    searchField.getTextField()?.superview?.clipsToBounds = false
                    searchField.clipsToBounds = false
                    searchField.getTextField()?.layer.borderColor = borderColor
                    reloadButton.layer.borderWidth = 0
                    reloadButton.layer.borderColor = borderColor
                    
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
            #endif
        } else {
            // Fallback on earlier versions
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        #if targetEnvironment(macCatalyst)
            print("oh")
        #else
            if !UserDefaults.standard.bool(forKey: "scrollSelection") {
                resetScroll()
                if scrollView.contentOffset.y <= -150 {
                    print("reload")
                    reload(UILabel())
                } else if scrollView.contentOffset.y <= -100 {
                    print("Search Bar")
                    sortWithLabels(UILabel())
                } else if scrollView.contentOffset.y <= -50 {
                    print("Filter Button")
                    searchField.becomeFirstResponder()
                    searchField.getTextField()?.layer.borderWidth = 0
                }
                filterButton.tintColor = UIColor(named: "Carl and Shannen")
                searchField.setTextField(color: UIColor(named: "Carlie White")!)
                reloadButton.tintColor = UIColor(named: "Carl and Shannen")
                
                resetScroll()
            }
        #endif
    }
    
    func resetScroll() {
        filterButton.layer.borderWidth = 0
        searchField.getTextField()?.layer.borderWidth = 0
        reloadButton.layer.borderWidth = 0
    }
    
    
}
