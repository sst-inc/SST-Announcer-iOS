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
            textLabel?.text = "\(title)"
            
            // Getting the filter icon image
            DispatchQueue.global(qos: .background).async {
                
                // Creating image configuration, medium
                let config = UIImage.SymbolConfiguration(weight: .medium)
                
                // Creating the image from the image received from the title
                let image = Fetch.getImage(self.title).withConfiguration(config)
                
                // Updating the User Interface
                DispatchQueue.main.async {
                    
                    // Update the image
                    self.imageView?.image = image
                    
                    // Set the tint color to system blue from clear to show image
                    self.imageView?.tintColor = .systemBlue
                    
                    // Setting as aspect fit so it will not be distorted
                    self.imageView?.contentMode = .scaleAspectFit
                }
            }
            
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
