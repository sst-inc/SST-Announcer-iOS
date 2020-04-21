//
//  ContentViewControllerTextField.swift
//  Announcer
//
//  Created by JiaChen(: on 21/4/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension ContentViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if #available(iOS 13.0, *) {
            #if targetEnvironment(macCatalyst)
            #else
            if !UserDefaults.standard.bool(forKey: "scrollSelection") {
                
                // Pin Button highlighted
                if scrollView.contentOffset.y <= -150 {
                    let offset = (scrollView.contentOffset.y * -1 - 150) / 100
                    
                    safariButton.layer.borderWidth = 0
                    safariButton.layer.borderColor = borderColor
                    
                    backButton.layer.borderWidth = 0
                    backButton.layer.borderColor = borderColor
                    
                    shareButton.layer.borderWidth = 0
                    shareButton.layer.borderColor = borderColor
                    
                    pinButton.layer.borderWidth = 25 * offset
                    pinButton.layer.borderColor = borderColor
                    
                    if playedHaptic != 1 {
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                    }
                    playedHaptic = 1
                }
                    
                    // Share button highlighted
                else if scrollView.contentOffset.y <= -112.5 {
                    let offset = (scrollView.contentOffset.y * -1 - 112.5) / 100
                    
                    safariButton.layer.borderWidth = 0
                    safariButton.layer.borderColor = borderColor
                    
                    backButton.layer.borderWidth = 0
                    backButton.layer.borderColor = borderColor
                    
                    shareButton.layer.borderWidth = 25 * offset
                    shareButton.layer.borderColor = borderColor
                    
                    pinButton.layer.borderWidth = 0
                    pinButton.layer.borderColor = borderColor
                    
                    if playedHaptic != 2 {
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                    }
                    playedHaptic = 2
                }
                    
                    // Back button highlighted
                else if scrollView.contentOffset.y <= -75 {
                    let offset = (scrollView.contentOffset.y * -1 - 75) / 100
                    
                    safariButton.layer.borderWidth = 0
                    safariButton.layer.borderColor = borderColor
                    
                    backButton.layer.borderWidth = 25 * offset
                    backButton.layer.borderColor = borderColor

                    shareButton.layer.borderWidth = 0
                    shareButton.layer.borderColor = borderColor
                    
                    pinButton.layer.borderWidth = 0
                    pinButton.layer.borderColor = borderColor
                    
                    if playedHaptic != 3 {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                    
                    playedHaptic = 3
                }
                    
                    // Safari button highlighted
                else if scrollView.contentOffset.y <= -37.5 {
                    let offset = (scrollView.contentOffset.y * -1 - 37.5) / 100
                    
                    safariButton.layer.borderWidth = 25 * offset
                    safariButton.layer.borderColor = borderColor
                    
                    backButton.layer.borderWidth = 0
                    backButton.layer.borderColor = borderColor
                    
                    shareButton.layer.borderWidth = 0
                    shareButton.layer.borderColor = borderColor
                    
                    pinButton.layer.borderWidth = 0
                    pinButton.layer.borderColor = borderColor
                    
                    if playedHaptic != 4 {
                        
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    playedHaptic = 4
                }
                    
                    // Reset
                else {
                    resetScroll()
                    playedHaptic = 0
                }
            }
            #endif
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        #if targetEnvironment(macCatalyst)
        #else
            if !UserDefaults.standard.bool(forKey: "scrollSelection") {
                resetScroll()
                if scrollView.contentOffset.y <= -150 {
                    // Pin button highlighted
                    pinnedItem(scrollView)
                    
                } else if scrollView.contentOffset.y <= -112.5 {
                    // Share button highlighted
                    sharePost(scrollView)
                    
                } else if scrollView.contentOffset.y <= -75 {
                    // Back button highlighted
                    dismiss(scrollView)
                    
                } else if scrollView.contentOffset.y <= -37.5 {
                    // Safari button highlighted
                    openPostInSafari(scrollView)
                    
                }
                
                resetScroll()
            }
        #endif
    }
    
    func resetScroll() {
        safariButton.layer.borderWidth = 0
        backButton.layer.borderWidth = 0
        shareButton.layer.borderWidth = 0
        pinButton.layer.borderWidth = 0
    }
}
