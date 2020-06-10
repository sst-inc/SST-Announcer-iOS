//
//  FilterTableViewCell.swift
//  Announcer
//
//  Created by JiaChen(: on 28/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    // Store the filter title
    // When set, update label
    var title = String() {
        didSet {
            // When the title variable is changed or set, update the titleLabel
            titleLabel.text = title
        }
    }
    
    // Just a view with color and a corner radius
    @IBOutlet weak var primaryView: UIView!
    
    // Contains the filter
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Curve the primary view
        primaryView.layer.cornerRadius = 10
    }

}
