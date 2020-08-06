//
//  ContentUpdates.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit
import URLEmbeddedView

extension ContentViewController {
    func updateContent() {
        // Render HTML from String
        // Handle WebKit requirements by showing an error

        // Check if need to show message
        let showError = I.phone || (splitViewController as? SplitViewController)?.announcementVC.searchField.text == ""

        if post.content.contains("webkitallowfullscreen=\"true\"") ||
            (attributedContent?.string.lowercased() ?? "").contains("error") &&
            showError {

            postRequiresWebKit()
        } else {
            // Getting HTML content
            let content = post.content
            
            // Converting HTML content to NSAttributedString
            // Receiving attributedContent from previous VC, if it doesnt exist, just load it
            let attr = attributedContent ?? content.htmlToAttributedString
            
            // Adding font and background color that support dark mode
            attr?.addAttribute(.font,
                               value: UIFont.systemFont(ofSize: currentScale, weight: .medium),
                               range: NSRange(location: 0, length: (attr?.length)!))
            
            attr?.addAttribute(.backgroundColor,
                               value: UIColor.clear,
                               range: NSRange(location: 0, length: (attr?.length)!))
            
            // Optimising for iOS 13 dark mode
            attr?.addAttribute(.foregroundColor,
                               value: UIColor.label,
                               range: NSRange(location: 0, length: (attr?.length)!))
            
            DispatchQueue.main.async {
                // Set the attributed text
                self.contentTextView.attributedText = attr
            }
        }
        
        // Update labels/textview with data
        let attrTitle = titleAttributes(post.title)
        // Find the [] and just make it like red or something
        
        // Format date as "1 Jan 2019"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = NSLocalizedString("DATE_FORMAT",
                                                     comment: "Posted on 6 Aug 2020")
        
        // Escape to main thread to update user interface
        DispatchQueue.main.async {
            // Update textLabel with attributed text for colored square brackets
            self.titleLabel.attributedText = attrTitle
            
            // Update the page title
            UIApplication.shared.connectedScenes.first?.title = self.post.title
            
            // Update dateLabel with formatted date
            self.dateLabel.text = dateFormatter.string(from: self.post.date)
            
            // Reload labels collection view with new data
            self.labelsCollectionView.reloadData()
        }
        
        // Handling pinned posts
        handlePinned(with: post)
        
        // Load in links asyncronously as it takes a while to generate images etc. for images
        loadLinks(from: post)
    }
    
    // Updating pinned values
    func updatePinned() {
        let pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        if pinnedItems.contains(post) {
            // Item is pinned
            isPinned = true

            // Set the image
            pinButton.setImage(Assets.unpin, for: .normal)
        } else {
            // Item is not pinned
            isPinned = false

            // Set the image
            pinButton.setImage(Assets.pin, for: .normal)
        }
    }
    
    func loadLinks(from post: Post) {
        DispatchQueue.global(qos: .utility).async {
            self.links = []
            
            for url in LinkFunctions.getLinksFromPost(post: post) {
                OGDataProvider.shared.fetchOGData(withURLString: url.absoluteString) { [weak self] ogData, error in
                    if error != nil { return }
                    
                    // Getting sourceURL
                    let sourceUrl: String = (ogData.sourceUrl ?? url).absoluteString
                    
                    // Getting page title
                    let pageTitle: String = {
                        // Get newURL
                        let newURL = url.baseURL?.absoluteString ?? url.absoluteString
                        
                        // Handling title for Google Sites
                        if newURL.contains("sites.google.com") {
                            var urlItems = newURL.split(separator: "/")
                            
                            // Remove the first 3 items as it is "https", "sites.google.com" and the domain thing
                            urlItems.removeFirst(3)
                            
                            // Return item
                            return urlItems.joined(separator: "/")
                        }
                        
                        // Setting page title, if not found, just use the URL
                        return ogData.pageTitle ?? newURL
                    }()
                    
                    // Adding thumbnail image
                    let sourceImage: UIImage? = {
                        
                        // Handling imageURL
                        if let imgUrl = ogData.imageUrl {
                            return try? UIImage(data: Data(contentsOf: imgUrl), scale: 1)
                        }
                        return nil
                    }()
                    
                    // Append latest link to links
                    self?.links.append(Links(title: pageTitle, link: sourceUrl, image: sourceImage))
                }
            }
        }
    }
}
