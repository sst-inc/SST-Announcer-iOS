//
//  AnnouncementPreviewing.swift
//  Announcer
//
//  Created by JiaChen(: on 13/12/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import UIKit

// This extension is for iOS 13 and above
// It provides options when user Long Presses (for devices without 3D touch), 3D touch or Force touch (MacOS Catalyst)
extension AnnouncementsViewController: UIContextMenuInteractionDelegate {
    // Set up items in the menu
    // Menu should contain Open announcements, Unpin / Pin, Share
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let cell = interaction.view as! AnnouncementTableViewCell
        
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in // menu elements from responder chain if any
            // Creating actions…
            // Checking if the current post is pinned
            let pinned = self.pinned.contains(cell.post)
            
            let pin = UIAction(title: {
                // If the post is pinned, set it to unpin
                pinned ? "Unpin" : "Pin"
            }(),
                               image: {
                                // Setting different image based the state of the post (pinned or unpinned)
                                pinned ? Assets.unpin : Assets.pin
            }(),
                               identifier: nil,
                               discoverabilityTitle: nil,
                               attributes: [],
                               state: .off) { (_) in
                                print("tapped")
                                
                                // Pin / Unpin post
                                // Pull pinned items from the file (load the latest version)
                                var pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
                                
                                if pinned {
                                    // Unpin post
                                    pinnedItems.remove(at: pinnedItems.firstIndex(of: cell.post)!)
                                } else {
                                    // Pin post
                                    pinnedItems.append(cell.post)
                                }
                                
                                // Write back to the file
                                PinnedAnnouncements.saveToFile(posts: pinnedItems)
                                
                                // Reload the local pinned variable
                                self.pinned = PinnedAnnouncements.loadFromFile() ?? []
                                
                                // Reload TableView to show the new pinned / unpinned post
                                self.announcementTableView.reloadData()
            }
            
            let share = UIAction(title: "Share...",
                                 image: Assets.share,
                                 identifier: nil,
                                 discoverabilityTitle: nil,
                                 attributes: [],
                                 state: .off) { (_) in
                                    //Create Activity View Controller (Share screen)
                                    let shareViewController = UIActivityViewController.init(activityItems: [LinkFunctions.getShareURL(with: cell.post)], applicationActivities: nil)
                                    
                                    //Remove unneeded actions
                                    shareViewController.excludedActivityTypes = [.saveToCameraRoll, .addToReadingList]
                                    
                                    //Present share sheet
                                    shareViewController.popoverPresentationController?.sourceView = cell
                                    self.present(shareViewController, animated: true, completion: nil)
            }
            
            let open = UIAction(title: "Open Announcement",
                                image: Assets.open,
                                identifier: nil,
                                discoverabilityTitle: nil,
                                attributes: [], state: .off) { (_) in
                                    
                                    // Setting selectedItem to the current selected item
                                    self.selectedItem = cell.post
                                    
                                    // Open post
                                    self.openPostFromPreview(with: cell)
            }
            
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: [],
                          children: [open, pin, share])
        }
        
        return UIContextMenuConfiguration(identifier: GlobalIdentifier.openPostPreview,
                                          previewProvider: { () -> UIViewController? in
                                            if self.splitViewController != nil {
                                                return nil
                                            }
                                            
                                            // Getting contentVC from post
                                            let contentVC = self.getContentViewController(with: cell.post)
                                            
                                            // Setting attributedContent in the contentVC
                                            contentVC.attributedContent = cell.htmlAttr
                                            
                                            // Return the contentVC
                                            return contentVC
        },
                                          actionProvider: actionProvider)
        
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        // Getting cell from interaction
        let cell = interaction.view as! AnnouncementTableViewCell
        
        // Setting selectedItem to the current selected item
        selectedItem = cell.post
        
        // Open post
        openPostFromPreview(with: cell)
    }
    
    func openPostFromPreview(with cell: AnnouncementTableViewCell) {
        // Appending posts to read posts
        var readAnnouncements = ReadAnnouncements.loadFromFile() ?? []
        readAnnouncements.append(cell.post)
        ReadAnnouncements.saveToFile(posts: readAnnouncements)
        
        // If user is viewing the splitViewController, open in the SVC
        if let splitVC = self.splitViewController as? SplitViewController {
            
            // Setting the post in the contentVC
            splitVC.contentVC.post = cell.post
            
            // Setting html attributed string
            splitVC.contentVC.attributedContent = cell.htmlAttr
            
            // Highlight the selected post
            cell.highlightPost = true
            
            // Getting previous cell to remove highlight
            if let previousCell = self.announcementTableView.cellForRow(at: self.selectedPath) as? AnnouncementTableViewCell {
                previousCell.highlightPost = false
            }
            
            // Update selected path
            let path = self.announcementTableView.indexPath(for: cell)
            self.selectedPath = path!
            
            // Change read indicator
            cell.handlePinAndRead()
            
        } else {
            // Get contentVC from post
            let contentVC = self.getContentViewController(with: cell.post)
            
            // Present contentVC through navigation controller
            self.navigationController?.pushViewController(contentVC, animated: true)
        }
    }
    
    // Getting contentVC from post
    func getContentViewController(with post: Post) -> ContentViewController {
        guard let contentVC = Storyboards.content.instantiateInitialViewController() as? ContentViewController else {
            fatalError()
        }
        
        // Set the post in contentVC
        contentVC.post = post
        
        // Handling when contentVC is dismissed
        contentVC.onDismiss = {
            // Do this on main as it requires updating the user interface
            DispatchQueue.main.async {
                // This updates the pinned items and read indicators and any updates made from contentVC
                
                // Reload announcementTableView
                self.announcementTableView.reloadData()
                
                // Reload data with the sender as contentVC
                self.reload(contentVC)
            }
        }
        
        // Return contentVC
        return contentVC
    }
    
    // Getting the contentViewController
    func getContentViewController(for indexPath: IndexPath) -> ContentViewController {
        
        // Getting contentVC
        guard let contentVC = Storyboards.content.instantiateInitialViewController() as? ContentViewController else {
            fatalError()
        }
        
        /// The post is the `selectedItem` in this case
        contentVC.post = selectedItem
        
        // Handling when contentVC is dismissed
        contentVC.onDismiss = {
            // Do this on main as it requires updating the user interface
            DispatchQueue.main.async {
                // This updates the pinned items and read indicators and any updates made from contentVC
                
                // Reload announcementTableView
                self.announcementTableView.reloadData()
                
                // Reload data with the sender as contentVC
                self.reload(contentVC)
            }
        }
        
        // Return contentVC
        return contentVC
    }

}
