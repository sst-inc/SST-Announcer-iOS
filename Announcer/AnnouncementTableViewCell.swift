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
        didSet {
            announcementTitleLabel.text = post.title
            announcementContentLabel.text = post.content
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            announcementDateLabel.text = "Posted on \(dateFormatter.string(from: post.date))"
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

}
