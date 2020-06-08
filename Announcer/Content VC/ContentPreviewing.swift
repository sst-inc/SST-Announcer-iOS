//
//  ContentPreviewing.swift
//  Announcer
//
//  Created by JiaChen(: on 6/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension ContentViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        if let cell = interaction.view as? LinksCollectionViewCell {
            // Creating contextual menu (for previewing) for LinksCollectionViewCell
            // Show open link, copy link and share button
            // If they click on the preview, open Safari View Controller
            
            /// The link is retrieved from the cell `cell.link.link`
            let link = URL(string: cell.link.link)!

            /// Creating safari view controller to be used by open link and when user clicks the preview
            let safariVC = SFSafariViewController(url: link)
            
            // Creating action provider for UIMenu
            // This creates right click support for iPadOS and MacOS as well
            // This also creates preview support for iOS and iPadOS
            let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in // menu elements from responder chain if any
                
                // Adding openLink button
                let openLink = UIAction(title: "Open Link",
                                        image: Assets.safari,
                                        identifier: nil,
                                        discoverabilityTitle: nil,
                                        attributes: [],
                                        state: .off) { (_) in
                                            // Open link
                                            
                                            // Preset safari view controller to the user
                                            self.present(safariVC, animated: true)
                }
                
                // Adding copy link button
                let copyLink = UIAction(title: "Copy Link",
                                        image: Assets.copy,
                                        identifier: nil,
                                        discoverabilityTitle: nil,
                                        attributes: [],
                                        state: .off) { (_) in
                                            // Copy link
                                            
                                            // Add cell's URL to pasteboard as a url
                                            // This will make it easier for the user when they want to paste it into Safari or open it from spotlight search prompt
                                            UIPasteboard.general.url = link
                }
                
                // Sharing the link
                let share = UIAction(title: "Share...",
                                     image: Assets.share,
                                     identifier: nil,
                                     discoverabilityTitle: nil,
                                     attributes: [],
                                     state: .off) { (_) in
                                        // Create Activity View Controller (Share screen)
                                        let shareViewController = UIActivityViewController.init(activityItems: [URL(string: cell.link.link)!], applicationActivities: nil)
                                        
                                        // Remove unneeded actions
                                        // You do not need to save a link to camera roll - i think
                                        shareViewController.excludedActivityTypes = [.saveToCameraRoll]
                                        
                                        // Adding sourceView for fancy arrow pointing to sourceView on iPadOS and MacOS
                                        shareViewController.popoverPresentationController?.sourceView = cell
                                        
                                        // Present share sheet
                                        self.present(shareViewController, animated: true, completion: nil)
                }
                
                // Creating a menu
                // Setting the children as the actions
                return UIMenu(title: "",
                              image: nil,
                              identifier: nil,
                              options: [],
                              children: [openLink, copyLink, share])
            }
            
            // Creating a context menu
            // Present safari view controller if user taps on preview
            return UIContextMenuConfiguration(identifier: GlobalIdentifier.linksSelection,
                                              previewProvider: { () -> UIViewController? in
                                                return safariVC
            },
                                              actionProvider: actionProvider)
        } else if let cell = interaction.view as? CategoriesCollectionViewCell {
            // creating contextual menu for CategoriesCollectionViewCell
            // Filter post and copy filter are the actions
            // Don't present a ViewController when tapped
            
            // Filter content from cell
            let filterContent = cell.titleLabel.text!
            
            // Creating action provider
            let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in // menu elements from responder chain if any
                
                // Filter posts
                let filterPost = UIAction(title: "Filter Posts",
                                          image: Assets.filter,
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          attributes: [],
                                          state: .off) { (_) in
                                            
                                            // Updating filter with new filter content
                                            self.updatedFilter(newFilter: filterContent)
                }
                
                // Copying filter term out
                // Why? Not sure either.
                let copyFilter = UIAction(title: "Copy Filter",
                                          image: Assets.copy,
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          attributes: [],
                                          state: .off) { (_) in
                                            // Copy filter
                                            
                                            // Copy filter content as a string
                                            UIPasteboard.general.string = filterContent
                }
                
                // Creating menu, children are the actions
                return UIMenu(title: "",
                              image: nil,
                              identifier: nil,
                              options: [],
                              children: [filterPost, copyFilter])
            }
            
            // Presenting menu
            return UIContextMenuConfiguration(identifier: GlobalIdentifier.filterSelection,
                                              previewProvider: nil,
                                              actionProvider: actionProvider)
        }
        
        // Return nil if there is nothing to handle
        return nil
    }
    
    // Handling when clicking on preview
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        // This should only need to work for categoriesCollectionViewCell as links just launch Safari View Controller
        // Safari VC is handled on the other function
        // All this has to do is launch a filter
        if let cell = interaction.view as? CategoriesCollectionViewCell {
            // Filter content from cell
            let filterContent = cell.titleLabel.text!
            
            // Updating filter with new filter content
            self.updatedFilter(newFilter: filterContent)
        }
    }
}
