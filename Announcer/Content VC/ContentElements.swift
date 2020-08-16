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
        // Update labels/textview with data
        let attrTitle = NSMutableAttributedString(string: string)
        // Find the [] and just make it like red or something
        
        // Make square brackets colored
        let indicesStart = attrTitle.string.indicesOf(string: "[")
        let indicesEnd = attrTitle.string.indicesOf(string: "]")
        
        // Determine which one is smaller (start indices or end indices)
        if (indicesStart.count >= (indicesEnd.count) ? indicesStart.count : indicesEnd.count) > 0 {
            for i in 1...(indicesStart.count >= indicesEnd.count ? indicesStart.count : indicesEnd.count) {
                
                let start = indicesStart[i - 1]
                let end = indicesEnd[i - 1]
                
                // [] colors will be Grey 1
                // @shannen why these color names man
                let bracketStyle: [NSAttributedString.Key: Any] = [.foregroundColor: GlobalColors.blueTint,
                                                                   .font: UIFont.systemFont(ofSize: 22,
                                                                                            weight: .semibold)]
                
                attrTitle.addAttributes(bracketStyle, range: NSRange(location: start, length: end - start + 2))
            }
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
