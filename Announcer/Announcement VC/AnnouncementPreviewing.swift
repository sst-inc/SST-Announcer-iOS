//
//  AnnouncementPreviewing.swift
//  Announcer
//
//  Created by JiaChen(: on 13/12/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import UIKit

// iOS 12 and under
// This extension is for the 3D touch options for iOS 12 and under. It will simply peek and pop. No options.
extension AnnouncementsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = announcementTableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = announcementTableView.rectForRow(at: indexPath)
            return getContentViewController(for: indexPath)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func getContentViewController(for indexPath: IndexPath) -> ContentViewController {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? ContentViewController else {
            fatalError()
        }
        let cell = announcementTableView.cellForRow(at: indexPath) as! AnnouncementTableViewCell
        
        vc.post = selectedItem
        vc.onDismiss = {
            DispatchQueue.main.async {
                self.announcementTableView.reloadData()
                self.reload(UILabel())
            }
            
        }
        
        return vc
    }
}

// This extension is for iOS 13 and above
// It provides options when user Long Presses (for devices without 3D touch), 3D touch or Force touch (MacOS Catalyst)
@available(iOS 13.0, *)
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
                                pinned ? UIImage(systemName: "pin.fill")! : UIImage(systemName: "pin")!
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
            
            let share = UIAction(title: "Share",
                                 image: UIImage(systemName: "square.and.arrow.up"),
                                 identifier: nil,
                                 discoverabilityTitle: nil,
                                 attributes: [],
                                 state: .off) { (_) in
                                    //Create Activity View Controller (Share screen)
                                    let shareViewController = UIActivityViewController.init(activityItems: [getShareURL(with: cell.post)], applicationActivities: nil)
                                    
                                    //Remove unneeded actions
                                    shareViewController.excludedActivityTypes = [.saveToCameraRoll, .addToReadingList]
                                    
                                    //Present share sheet
                                    shareViewController.popoverPresentationController?.sourceView = self.view
                                    self.present(shareViewController, animated: true, completion: nil)
            }
            
            let open = UIAction(title: "Open Announcement",
                                image: UIImage(systemName: "envelope.open"),
                                identifier: nil,
                                discoverabilityTitle: nil,
                                attributes: [], state: .off) { (_) in
                                    self.selectedItem = cell.post
                                    
                                    // Appending posts to read posts
                                    var readAnnouncements = ReadAnnouncements.loadFromFile() ?? []
                                    readAnnouncements.append(cell.post)
                                    ReadAnnouncements.saveToFile(posts: readAnnouncements)
                                    
                                    let vc = self.getContentViewControllerThroughPreview(with: cell.post)
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    
            }
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: [],
                          children: [open, pin, share])
        }
        return UIContextMenuConfiguration(identifier: "my identifier" as NSCopying,
                                          previewProvider: { () -> UIViewController? in
                                            self.getContentViewControllerThroughPreview(with: cell.post)
        },
                                          actionProvider: actionProvider)
        
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let cell = interaction.view as! AnnouncementTableViewCell
        self.selectedItem = cell.post
        
        // Appending posts to read posts
        var readAnnouncements = ReadAnnouncements.loadFromFile() ?? []
        readAnnouncements.append(cell.post)
        ReadAnnouncements.saveToFile(posts: readAnnouncements)
        
        let vc = self.getContentViewControllerThroughPreview(with: cell.post)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getContentViewControllerThroughPreview(with post: Post) -> ContentViewController {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? ContentViewController else {
            fatalError()
        }
        
        vc.post = post
        vc.onDismiss = {
            DispatchQueue.main.async {
                self.announcementTableView.reloadData()
                self.reload(UILabel())
            }
            
        }
        
        return vc
    }
    
}
