//
//  FeedbackButton.swift
//  Announcer
//
//  Created by JiaChen(: on 22/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import SafariServices

class FeedbackButton: UIView {

    let feedbackButton = UIImageView()
    
    // Parent View Controller used to display the feedback form
    var parent: AnnouncementsViewController?
    
    // Stack View
    var stack: UIStackView!
    
    // Stack view elements
    // - "Feedback" label
    var label: UILabel!
    
    // - Feedback icon image view
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        
        // UI elements
        let stack = UIStackView()
        
        // - Stack Children
        let label = UILabel()
        let imageView = UIImageView()
        
        // - Gesture recognizer
        // Handling when user taps the Feedback Button
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        
        // Handling when user hovers over button on iPadOS and MacOS
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(onHover(sender:)))
        
        // Setting up "Feedback" label
        // - Setting the feedback title
        label.text = "Feedback"
        
        // - Setting the font
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        // - Setting the text color to be the blue tint
        label.textColor = GlobalColors.blueTint
        
        // - Setting up for constraints
        label.translatesAutoresizingMaskIntoConstraints = false

        
        // Setting up image view
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
        
        
        // Setting up Stack view
        // - Creating horizontal stack view
        stack.axis = .horizontal
        
        // - Setting stack spacing
        stack.spacing = 16
        
        // - Setting view distribution to ensure views don't get cut
        stack.distribution = .fillProportionally
        
        // - Setting up for constraints
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        // - Adding children to stack
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        // - StackView Contraints
        //   - Pin to leading and top
        //   - Center X and Y
        let stackConstraints = [NSLayoutConstraint(item: stack,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0),
                                NSLayoutConstraint(item: stack,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0),
                                NSLayoutConstraint(item: stack,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 16),
                                NSLayoutConstraint(item: stack,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .top,
                                                   multiplier: 1,
                                                   constant: 16)
        ]
        
        // Add the stack view's constraints
        addConstraints(stackConstraints)
        
        // Add the stack as a subview
        addSubview(stack)
        
        
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
        
        // Adding the tap gesture recognizer to the view
        // - Because it is a button
        addGestureRecognizer(tap)
        
        // - Add hover gesture recognizer to make things more... animated on MacOS and iPadOS
        addGestureRecognizer(hover)
        
        // Setting the variables
        self.label = label
        self.stack = stack
        self.imageView = imageView
    }
    
    
    /// Handling when feedback button clicked
    @objc func onClick() {
        
        /// Link of Feedback Google Forms
        let link = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSe-zFUjCBj2i0OZfQGpKDs3HQtjIU9cl_mbZCT03lPKDab25Q/viewform?usp=sf_link")!
        
        if I.mac {
            // If user is on MacOS, just open the link up
            UIApplication.shared.open(link)
        } else {
            // Otherwise, use safari view controllers to open the link
            let svc = SFSafariViewController(url: link)
            
            // Present the Safari view controller using the parent
            parent?.present(svc, animated: true, completion: nil)
        }
    }
    
    /// Handling when feedback button is hovered upon
    @objc func onHover(sender: UIHoverGestureRecognizer) {
        switch sender.state {
        case .began:
            // When the hover begins
            
            if parent!.announcementTableView.contentOffset.y > 25 {
                // Make sure we can open (it's not already opened)
                open()
            }
            
            // Set the background color to show the highlight,
            // mostly for dark mode users
            backgroundColor = .systemGray5
            
            // Make a subtle change in the shadows,
            // mostly for light mode users
            layer.shadowRadius = 6
            
        case .cancelled, .ended:
            // When user stops hovering over feedback button
            
            if parent!.announcementTableView.contentOffset.y > 25 {
                // Make sure that it can close to ensure consistency
                close()
            }
            
            // Resetting the background color, for dark mode users
            backgroundColor = .systemBackground
            
            // Resetting the shadows, for light mode users
            layer.shadowRadius = 10
        default:
            break
        }
    }
    
    /// Close feedback button
    /// Make it smaller to allow for more space for content when user scrolls
    func close() {
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.label.isHidden = true
        })
    }
    
    /// Open feedback button
    /// Open it up when user scrolls to top
    func open() {
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.label.isHidden = false
        })
    }
}
