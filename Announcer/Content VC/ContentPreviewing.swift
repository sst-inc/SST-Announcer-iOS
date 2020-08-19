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
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
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
                self.linksMenuItems(cell, link: link, safariVC: safariVC)
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

            // Creating action provider
            let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in // menu elements from responder chain if any
                self.categoriesMenuItems(cell)
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
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionCommitAnimating) {
        // This should only need to work for categoriesCollectionViewCell as links just launch Safari View Controller
        // Safari VC is handled on the other function
        // All this has to do is launch a filter
        if let cell = interaction.view as? CategoriesCollectionViewCell {
            // Filter content from cell
            var filterContent = cell.titleLabel.text!
            
            // Remove tabs
            if selectedFilter.contains("\t") {
                // Remove \t from filter
                selectedFilter.removeFirst(2)
            }

            // Updating filter with new filter content
            self.updatedFilter(newFilter: filterContent)
        }
    }
    
    func linksMenuItems(_ cell: LinksCollectionViewCell,
                        link: URL,
                        safariVC: SFSafariViewController) -> UIMenu {
        
        let openLinkLocalized = NSLocalizedString("ACTION_OPEN_LINK",
                                                  comment: "Open Link")
        
        // Adding openLink button
        let openLink = UIAction(title: openLinkLocalized,
                                image: Assets.safari,
                                identifier: nil,
                                discoverabilityTitle: nil,
                                attributes: [],
                                state: .off) { (_) in
                                    // Open link

                                    // Preset safari view controller to the user
                                    self.present(safariVC, animated: true)
        }

        let copyLinkLocalized = NSLocalizedString("ACTION_COPY_LINK",
                                                  comment: "Copy Link")

        // Adding copy link button
        let copyLink = UIAction(title: copyLinkLocalized,
                                image: Assets.copy,
                                identifier: nil,
                                discoverabilityTitle: nil,
                                attributes: [],
                                state: .off) { (_) in
            // Copy link

            // Add cell's URL to pasteboard as a url

            // This will make it easier for the user when they want to paste it into Safari
            // or open it from spotlight search prompt
            if I.mac {
                // MacOS does not copy URLs too well, so copy string for Macs
                UIPasteboard.general.string = link.absoluteString
            } else {
                // Copy as URL
                UIPasteboard.general.url = link
            }
        }

        // Sharing the link
        // Getting activity items
        let activityItems = [URL(string: cell.link.link)!]

        let shareLocalized = NSLocalizedString("ACTION_SHARE",
                                               comment: "Share...")

        let share = UIAction(title: shareLocalized,
                             image: Assets.share,
                             identifier: nil,
                             discoverabilityTitle: nil,
                             attributes: [],
                             state: .off) { (_) in
                                // Create Activity View Controller (Share screen)
                                let shareViewController = UIActivityViewController(activityItems: activityItems,
                                                                                   applicationActivities: nil)

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
    
    func categoriesMenuItems(_ cell: CategoriesCollectionViewCell) -> UIMenu {
        
        // Filter content from cell
        var filterContent = cell.titleLabel.text!
        
        if selectedFilter.contains("\t") {
            // Remove \t from filter
            selectedFilter.removeFirst(2)
        }

        let filterLocalized = NSLocalizedString("ACTION_FILTER",
                                                comment: "Filter Posts")
        
        // Filter posts
        let filterPost = UIAction(title: filterLocalized,
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
        let copyLocalized = NSLocalizedString("ACTION_COPY_FILTER",
                                              comment: "Copy Filter")
        
        let copyFilter = UIAction(title: copyLocalized,
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
}
