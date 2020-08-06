//
//  FeedbackButtonInterfaceElements.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension FeedbackButton {
    func setUpViewStyle() {
        // Setting up view's style
        // - Setting background color to system background so it will dynamically change
        backgroundColor = .systemBackground
        
        // - Adding corner radius to the button to make it round
        layer.cornerRadius = 25
        
        // - Creating shadows for the button
        //   - Set shadow color
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        //   - Set shadow opacity
        layer.shadowOpacity = 0.5
        
        //   - Set shadow offset, zero
        layer.shadowOffset = .zero
        
        //   - Set shadow radius
        layer.shadowRadius = 10
    }
    
    func getStackView() -> UIStackView {
        // Setting up Stack view
        let stack = UIStackView()
        
        // - Creating horizontal stack view
        stack.axis = .horizontal
        
        // - Setting stack spacing
        stack.spacing = 16
        
        // - Setting view distribution to ensure views don't get cut
        stack.distribution = .fillProportionally
        
        // - Setting up for constraints
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }
    
    func getLabel() -> UILabel {
        // Setting up "Feedback" label
        let label = UILabel()
        // - Setting the feedback title
        label.text = NSLocalizedString("ACTION_FEEDBACK",
                                       comment: "Feedback")
        
        // - Setting the font
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        // - Setting the text color to be the blue tint
        label.textColor = GlobalColors.blueTint
        
        // - Setting up for constraints
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
    
    func getImageView() -> UIImageView {
        // Setting up image view
        let imageView = UIImageView()
        
        // - Creating a configuration style for feedback SF Symbol
        let config = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 20), scale: .large)
        
        // - Setting the image of image view
        imageView.image = UIImage(systemName: "exclamationmark.bubble", withConfiguration: config)
        
        // - Ensuring the image does not get squished
        imageView.contentMode = .scaleAspectFit
        
        // - Setting the blue tint color
        imageView.tintColor = GlobalColors.blueTint
        
        // - Preparing for autolayout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
}
