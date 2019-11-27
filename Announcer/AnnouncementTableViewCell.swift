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
            let content: String = {
                return post.content.htmlToString.replacingOccurrences(of: "\n\n", with: "\n")
            }()
            announcementContentLabel.text = content
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            announcementDateLabel.text = "Posted on \(dateFormatter.string(from: post.date))"
            setTitleLabelText()
            endLoader()
        }
    }
    
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
    
    func startLoader() {
        announcementTitleLabel.showLoader()
        announcementTitleLabel.text = " "
        announcementContentLabel.showLoader()
        announcementContentLabel.text = " "
        announcementDateLabel.showLoader()
        announcementDateLabel.text = " "
    }
    
    func endLoader() {
        announcementTitleLabel.hideLoader()
        announcementContentLabel.hideLoader()
        announcementDateLabel.hideLoader()
    }
}
