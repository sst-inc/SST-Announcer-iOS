//
//  AnnouncementTableViewCell.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {

    var post: Post! {
        // If the post value is changed, set these values to whatever is below in didSet
        didSet {
            
            // Loading the content takes a while
            // Converting HTML to String is slow
            // Do conversion on different thread and update the cell when it's ready
            // Show loading to user
            
            if #available(iOS 13.0, *) {
                let str = NSMutableAttributedString.init(string: "")
                str.append(NSAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "arrow.clockwise")!)))
                str.append(NSAttributedString(string: "\tLoading Content...\n\n"))
                self.announcementContentLabel.attributedText = str
            } else {
                // Fallback on earlier versions
                self.announcementContentLabel.text = "Loading Content...\n\n"
            }
            
            DispatchQueue.main.async {
                self.announcementContentLabel.text = self.post.content.htmlToString
                // self.post.content.htmlToString.replacingOccurrences(of: "\n\n", with: "\n")
            }
            
            // Ensure date is formatted as 22 Oct 2019 using d MMM yyyy
            // The date is the date posted onto studentsblog
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            
            announcementDateLabel.text = "Posted on \(dateFormatter.string(from: post.date))"
            
            let pinned = PinnedAnnouncements.loadFromFile()
            
            if pinned?.contains(post) ?? false {
                announcementImageView.isHidden = false
                if #available(iOS 13.0, *) {
                    announcementImageView.image = UIImage(systemName: "pin.fill")!
                    announcementImageView.tintColor = UIColor(named: "Carl and Shannen")
                }
            } else {
                announcementImageView.isHidden = true
            }
            
            let readAnnouncements = ReadAnnouncements.loadFromFile() ?? []
            
            if !readAnnouncements.contains(post) {
                announcementImageView.isHidden = false
                if #available(iOS 13.0, *) {
                    announcementImageView.image = UIImage(systemName: "circle.fill")
                    announcementImageView.tintColor = .systemRed
                }
            }
            
            backgroundColor = UIColor(named: "Carlie White")
            
            // Set attributes of title label
            // [Square Brackets] all red to highlight things like [Sec 2 students] etc.
            // Set the text the label
            setTitleLabelText()
            
            // Hide all the loaders
            endLoader()
        }
    }
    
    @IBOutlet weak var announcementImageView: UIImageView!
    @IBOutlet weak var announcementTitleLabel: UILabel!
    @IBOutlet weak var announcementContentLabel: UILabel!
    @IBOutlet weak var announcementDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Color the brackets []
    // Make the text set
    func setTitleLabelText() {
        // Update labels/textview with data
        let attrTitle = NSMutableAttributedString(string: post.title)
        // Find the [] and just make it like red or something
        
        // Make square brackets colored
        let indicesStart = attrTitle.string.indicesOf(string: "[")
        let indicesEnd = attrTitle.string.indicesOf(string: "]")
        
        // Determine which one is smaller (start indices or end indices)
        if (indicesStart.count >= (indicesEnd.count) ? indicesStart.count : indicesEnd.count) > 0 {
            for i in 1...(indicesStart.count >= indicesEnd.count ? indicesStart.count : indicesEnd.count) {
                
                let start = indicesStart[i - 1]
                let end = indicesEnd[i - 1]
                
                // [] colors will be Carl and Shannen
                // @shannen why these color names man
                let bracketStyle : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .semibold)]
                
                attrTitle.addAttributes(bracketStyle, range: NSRange(location: start, length: end - start + 2))
            }
        }
        
        announcementTitleLabel.attributedText = attrTitle
    }
    
    // Using the KALoader for loading animations
    // Similar to YouTube
    // Set text as " " so as to maintain proper constraints
    func startLoader() {
        announcementTitleLabel.showLoader()
        announcementTitleLabel.text = " "
        
        announcementContentLabel.showLoader()
        announcementContentLabel.text = " "
        
        announcementDateLabel.showLoader()
        announcementDateLabel.text = " "
    }
    
    // Hide all loaders when content is present for user
    func endLoader() {
        announcementTitleLabel.hideLoader()
        announcementContentLabel.hideLoader()
        announcementDateLabel.hideLoader()
    }
}
