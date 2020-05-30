//
//  LinksCollectionViewCell.swift
//  Announcer
//
//  Created by JiaChen(: on 25/4/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit

class LinksCollectionViewCell: UICollectionViewCell {
    
    var link: Links! {
        didSet {
            if link.title.contains("https://") {
                // Removing the "https://" from a link
                link.title.removeFirst(8)
                
            } else if link.title.contains("http://") {
                // Removing the "http://" from a link
                link.title.removeFirst(7)
                
            } else if link.title.contains("mailto:") {
                // Removing the "mailto:" from a link
                link.title.removeFirst(7)
                
            }
            
            if link.title.contains("www.") {
                // Removing the "www" from a link
                link.title.removeFirst(4)
                
            }
            
            // Shortening the title because we cannot have a ridiculously long title
            titleLabel.text = link.title.truncateBy(20)
            thumbnailImageView.isHidden = false
            
            // Special icons
            thumbnailImageView.image = getImageFor(title: link.link, with: link.image)
            
            // Shortening the link because we cannot have a ridiculously long link
            linkLabel.text = link.link.truncateBy(30)
        }
    }
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    func getImageFor(title: String, with defaultImage: UIImage?) -> UIImage {
        if title.contains("mailto:") {
            // Handling Email Addresses
            return Assets.mail
            
        } else if title.contains("docs.google.com") || title.contains("paper.dropbox.com") || title.contains(".pdf") {
            // Handling Documents
            return Assets.docs
            
        } else if title.contains("drive.google.com") || title.contains("icloud.com") {
            // Handling Files and Folders
            return Assets.folder
            
        } else if title.contains("zoom.us") || title.contains("meet.google.com") || title.contains("skype") {
            // Handling Video Calls
            return Assets.call
            
        } else if title.contains("facebook") || title.contains("twitter") || title.contains("linkedin") || title.contains("instagram") || title.contains("linkedin") {
            // Handling Social Media
            return Assets.socialMedia
            
        } else if title.contains("youtube") {
            // Handling YouTube Videos
            return Assets.video
            
        } else if title.contains(".png") || title.contains(".jpg") || title.contains(".jpeg") || title.contains(".tiff") {
            // Handling Images
            return Assets.photo
            
        } else {
            // Hopefully getting a preview image
            if let img = defaultImage {
                return img
            } else {
                // Getting Favicon from Domain
                let data = (try? Data(contentsOf: URL(string: "https://www.google.com/s2/favicons?domain=\(title)")!)) ?? Assets.defaultLinkIcon.pngData()!
                
                // If there are no images, just use a Link icon
                let image = UIImage(data: data) ?? Assets.defaultLinkIcon
                
                return image
            }
        }
    }
    
}
