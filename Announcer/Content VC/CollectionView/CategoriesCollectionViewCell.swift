//
//  CategoriesCollectionViewCell.swift
//  Announcer
//
//  Created by JiaChen(: on 28/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func loadView() {
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(hovered(sender:)))
        
        contentView.addGestureRecognizer(hover)
    }
    
    @objc func hovered(sender: UIHoverGestureRecognizer) {
        switch sender.state {
        case .began:
            // When the hover begins
            
            
            // Set the background color to show the highlight,
            // mostly for dark mode users
            contentView.backgroundColor = .systemGray4
            
        case .cancelled, .ended:
            // When user stops hovering over feedback button
            
            // Resetting the background color, for dark mode users
            contentView.backgroundColor = GlobalColors.greyTwo
        default:
            break
        }

    }

}
