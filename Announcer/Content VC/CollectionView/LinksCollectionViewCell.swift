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
            titleLabel.text = link.title.truncateBy(20)
            thumbnailImageView.isHidden = false
            
            // Special icons
            if link.link.contains("mailto:") {
                thumbnailImageView.image = UIImage(systemName: "envelope.circle.fill")
            } else if link.link.contains("docs.google.com") || link.link.contains("paper.dropbox.com") || link.link.contains(".pdf") {
                thumbnailImageView.image = UIImage(systemName: "doc.circle.fill")
            } else if link.link.contains("sstinc.org") {
                thumbnailImageView.image = UIImage(systemName: "chevron.left.slash.chevron.right")
            } else if link.link.contains("drive.google.com") || link.link.contains("icloud.com") {
                thumbnailImageView.image = UIImage(systemName: "folder.circle.fill")
            } else if link.link.contains("zoom.us") || link.link.contains("meet.google.com") || link.link.contains("skype") {
                thumbnailImageView.image = UIImage(systemName: "phone.circle.fill")
            } else if link.link.contains(".png") || link.link.contains(".jpg") || link.link.contains(".jpeg") {
                thumbnailImageView.image = UIImage(systemName: "photo.fill")
            } else {
                if let img = link.image {
                    thumbnailImageView.image = img
                } else {
                    thumbnailImageView.image = UIImage(systemName: "link.circle.fill")
                }
            }
            
            linkLabel.text = link.link.truncateBy(30)
        }
    }
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
}
