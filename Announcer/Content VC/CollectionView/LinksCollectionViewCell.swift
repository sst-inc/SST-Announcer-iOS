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
            thumbnailImageView.image = getImageFor(title: link.link, with: link.image)
            
            linkLabel.text = link.link.truncateBy(30)
        }
    }
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    func getImageFor(title: String, with defaultImage: UIImage?) -> UIImage {
        if title.contains("mailto:") {
            return UIImage(systemName: "envelope.circle.fill")!
        } else if title.contains("docs.google.com") || title.contains("paper.dropbox.com") || title.contains(".pdf") {
            return UIImage(systemName: "doc.circle.fill")!
        } else if title.contains("drive.google.com") || title.contains("icloud.com") {
            return UIImage(systemName: "folder.circle.fill")!
        } else if title.contains("zoom.us") || title.contains("meet.google.com") || title.contains("skype") {
            return UIImage(systemName: "phone.circle.fill")!
        } else if title.contains("facebook") || title.contains("twitter") || title.contains("linkedin") || title.contains("instagram") {
            return UIImage(systemName: "person.crop.circle.fill")!
        } else if title.contains("youtube") || title.contains("") {
            return UIImage(systemName: "film.fill")!
        } else if title.contains(".png") || title.contains(".jpg") || title.contains(".jpeg") {
            return UIImage(systemName: "photo.fill")!
        } else {
            if let img = defaultImage {
                return img
            } else {
                // Getting Favicon from Domain (thanks google)
                let data = (try? Data(contentsOf: URL(string: "https://www.google.com/s2/favicons?domain=\(title)")!)) ?? UIImage(systemName: "link.circle.fill")!.pngData()!
                
                let image = UIImage(data: data) ?? UIImage(systemName: "link.circle.fill")!
                
                return image
            }
        }
    }
    
}
