//
//  FilterTableViewCell.swift
//  Announcer
//
//  Created by JiaChen(: on 28/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    var title = String() {
        didSet {
            // When the title variable is changed or set, update the titleLabel
            titleLabel.text = title
        }
    }
    
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        yellowView.layer.cornerRadius = 10
    }

}
