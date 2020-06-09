//
//  ContentCollectionView.swift
//  Announcer
//
//  Created by JiaChen(: on 21/4/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension ContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Setting the number of items in the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == labelsCollectionView {
            // Getting the number of items, aka the number of categories in the post
            let numberOfItems = post.categories.count
            
            // Return the number of categories in the post
            return numberOfItems
        } else {
            // Handling linksCollectionView
            
            // Return the number of links in the post
            return links.count
        }
    }
    
    // Setting the content of collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == labelsCollectionView {
            // Handling the Labels
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GlobalIdentifier.labelCell, for: indexPath) as! CategoriesCollectionViewCell
            
            // Set cell background color
            cell.backgroundColor = GlobalColors.greyTwo
            
            // Adding labels to cell
            cell.titleLabel.text = post.categories[indexPath.row]
            
            // Setting Cell Corner Radius
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            
            /// INTERACTIONS
            /// - Pointer interaction
            ///      iOS 13.4 and up, allows for fancy hover animations, refer to ContentPointer.swift
            if #available(iOS 13.4, *) {
                cell.addInteraction(UIPointerInteraction(delegate: self))
            }
            
            /// - Preview with context menu
            ///       Press & Hold or use 3D touch to open up context menu
            ///       Also works with pointer's secondary (right) click
            let interaction = UIContextMenuInteraction(delegate: self)
            
            /// Adding context menu interaction to cell
            cell.addInteraction(interaction)
            
            return cell
        } else {
            // Handling the Links
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GlobalIdentifier.linkCell, for: indexPath) as! LinksCollectionViewCell
            
            // Set cell background color
            cell.backgroundColor = GlobalColors.greyTwo
            
            // Setting up links
            cell.link = links[indexPath.row]
            
            // Setting Cell Corner Radius
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            
            /// INTERACTIONS
            /// - Pointer interaction
            ///      iOS 13.4 and up, allows for fancy hover animations, refer to `ContentPointer.swift`
            if #available(iOS 13.4, *) {
                cell.addInteraction(UIPointerInteraction(delegate: self))
            }
            
            /// - Preview with context menu
            ///       Press & Hold or use 3D touch to open up context menu
            ///       Also works with pointer's secondary (right) click
            let interaction = UIContextMenuInteraction(delegate: self)
            
            /// Adding context menu interaction to cell
            cell.addInteraction(interaction)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == labelsCollectionView {
            // Handling the Labels
            let cell = collectionView.cellForItem(at: indexPath) as! CategoriesCollectionViewCell
            
            // Update filters
            updatedFilter(newFilter: cell.titleLabel.text!)
        } else {
            // Handling the Links
            let cell = collectionView.cellForItem(at: indexPath) as! LinksCollectionViewCell
            
            // Handle if it is a "mailto:" or something else. Or just a normal URL.
            // When it is a normal URL, present a Safari View Controller
            // Otherwise just open the URL and iOS will handle it
            let url = URL(string: cell.link.link) ?? GlobalLinks.errorNotFoundURL
            
            let scheme = url.scheme
            
            // Only use safari view controller when scheme is http or https
            if scheme == "https" || scheme == "http" {
                // Create safari view controller
                let svc = SFSafariViewController(url: url)
                
                // Present safari vc
                present(svc, animated: true)
            } else {
                // This does not seem to work on simulator with mailto schemes
                // test on actual device
                UIApplication.shared.open(url)
            }
        }
    }
    
    /// Update search bar in `announcementViewController` with new data
    func updatedFilter(newFilter: String) {
        // Set global filter
        filter = newFilter
        
        // Run filter handler
        filterUpdated?()
        
        // Handling filter for non-iPadOS, go back to root vc
        navigationController?.popToRootViewController(animated: true)
        
        // Handling reload on announcement vc if user launches from splitViewControl
        // Getting announcement view controller
        if let announcementVC = (splitViewController as? SplitViewController)?.announcementVC {
            // Reload filters
            announcementVC.reloadFilter()
        }
    }
}
