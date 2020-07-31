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
        let stack = getStackView()
        
        // - Stack Children
        let label = getLabel()
        let imageView = getImageView()
        
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
        
        // Add the stack as a subview
        addSubview(stack)
        
        // Add the stack view's constraints
        addConstraints(stackConstraints)
        
        // Set up the view's style
        setUpViewStyle()
        
        // Add gesture recognizer
        setUpGestures()
        
        // Setting the variables
        self.label = label
        self.stack = stack
        self.imageView = imageView
    }
    
    // MARK: - Setting Gesture Recognizer
    func setUpGestures() {
        // Handling when user taps the Feedback Button
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        
        // Handling when user hovers over button on iPadOS and MacOS
        let hover = UIHoverGestureRecognizer(target: self, action: #selector(onHover(sender:)))
        
        // Adding the tap gesture recognizer to the view
        // - Because it is a button
        addGestureRecognizer(tap)
        
        // - Add hover gesture recognizer to make things more... animated on MacOS and iPadOS
        addGestureRecognizer(hover)
    }
        
    /// Handling when feedback button clicked
    @objc func onClick() {
        
        /// Link of Feedback Google Forms
        let link = URL(string: "https://go.sstinc.org/announcer-feedback")!
        
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
        UIView.animateKeyframes(withDuration: 0.2,
                                delay: 0,
                                options: [.allowUserInteraction, .beginFromCurrentState],
                                animations: {
                                    self.label.isHidden = true
                                })
    }
    
    /// Open feedback button
    /// Open it up when user scrolls to top
    func open() {
        UIView.animateKeyframes(withDuration: 0.2,
                                delay: 0,
                                options: [.allowUserInteraction, .beginFromCurrentState],
                                animations: {
                                    self.label.isHidden = false
                                })
    }
}
