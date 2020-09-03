//
//  ContentInterface.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension ContentViewController {
    func titleAttributes(_ string: String) -> NSAttributedString {
        
        let font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label,
                                                                .font: font]
        
        // Update labels/textview with data
        let attrTitle = NSMutableAttributedString(string: post.title, attributes: defaultAttributes)
        
        // Find the [] and just make it like red or something
        let regexSquareBrackets = try! NSRegularExpression(pattern: "\\[[ \\t\\r\\n\\v\\fA-Za-z0-9_]+\\]")
        let regexBracket = try! NSRegularExpression(pattern: "\\([ \\t\\r\\n\\v\\fA-Za-z0-9_]+\\)")

        let squareMatches = regexSquareBrackets.matches(in: post.title,
                                                  options: [],
                                                  range: NSRange(location: 0, length: post.title.count)).map {
                                                    $0.range
                                                  }
        
        let bracketMatches = regexBracket.matches(in: post.title,
                                                  options: [],
                                                  range: NSRange(location: 0, length: post.title.count)).map {
                                                    $0.range
                                                  }
        
        for range in squareMatches {
            
            // `[]` colors will be `.blueTint`
            // Setting the bracket style
            let bracket: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "Text Red")!,
                                                          .font: font]
            
            // Add the blue to the squared brackets in the title
            attrTitle.addAttributes(bracket,
                                    range: range)
        }
        
        for range in bracketMatches {
            
            // `[]` colors will be `.blueTint`
            // Setting the bracket style
            let bracket: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "Text Blue")!,
                                                          .font: font]
            
            // Add the blue to the squared brackets in the title
            attrTitle.addAttributes(bracket,
                                    range: range)
        }
        
        return attrTitle
    }
    
    func resetInterface() {
        // Set textField delegate
        if contentTextView != nil {
            self.contentTextView.delegate = self
        }
        
        // Styling default font size button
        // Create a button of corner radius 20
        if defaultFontSizeButton != nil {
            self.defaultFontSizeButton.layer.cornerRadius = 20
            self.defaultFontSizeButton.clipsToBounds = true
            
            // Hide the button until needed
            self.defaultFontSizeButton.isHidden = true
        }
        
        // Setting corner radii for the scrollSelection buttons to allow for the circular highlight
        if self.safariButton != nil {
            self.safariButton.layer.cornerRadius = 25 / 2
        }
        
        if self.shareButton != nil {
            self.shareButton.layer.cornerRadius = 25 / 2
        }
        
        if self.pinButton != nil {
            self.pinButton.layer.cornerRadius = 25 / 2
        }
        
        // Hide links view while loading links
        if self.linksView != nil {
            self.linksView.isHidden = true
        }
    }
    
    func handlePinned(with post: Post) {
        // Check if item is pinned
        // Update the button to show
        //If is in pinnned
        let pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        
        DispatchQueue.main.async {
            // Fill/Don't fill pin
            if pinnedItems.contains(post) {
                // Set the isPinned variable
                self.isPinned = true
                
                // Updating the pinButton image to unpin
                if self.pinButton != nil {
                    self.pinButton.setImage(Assets.unpin, for: .normal)
                }
            } else {
                // Set the isPinned variable
                self.isPinned = false
                
                // Updating the pinButton image to pin
                if self.pinButton != nil {
                    self.pinButton.setImage(Assets.pin, for: .normal)
                }
            }
                        
            // Hide the labels if there are none
            if self.post.categories.count == 0 {
                
                if self.labelsView != nil {
                    self.labelsView.isHidden = true
                }
                
                if self.seperatorView != nil {
                    self.seperatorView.isHidden = true
                }
                
            } else {
                if self.labelsView != nil {
                    self.labelsView.isHidden = false
                }
            }
            
            self.resetInterface()
        }
    }
    
    @objc func updateSize() {
        // Updating the current scale of the text
        let userDefaultsScale = UserDefaults.standard.float(forKey: UserDefaultsIdentifiers.textScale.rawValue)
        
        currentScale = userDefaultsScale == 0 ? GlobalIdentifier.defaultFontSize : CGFloat(userDefaultsScale)

        DispatchQueue.main.async {
            // New font size and style
            let font = UIFont.systemFont(ofSize: self.currentScale, weight: .medium)

            // Creating attributed text
            let attr = NSMutableAttributedString(attributedString: self.contentTextView.attributedText)

            // Setting text color using NSAttributedString
            attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: attr.length))

            // Setting attributedText on contentTextView
            self.contentTextView.attributedText = attr
        }
    }
}
