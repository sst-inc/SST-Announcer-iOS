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
            if !UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.scrollSelection.rawValue) {
                
                // Pin Button highlighted
                if scrollView.contentOffset.y <= -4 * scrollSelectionMultiplier {
                    ScrollSelection.setNormalState(for: safariButton)
                    ScrollSelection.setNormalState(for: backButton)
                    ScrollSelection.setNormalState(for: shareButton)
                    
                    ScrollSelection.setSelectedState(for: pinButton,
                                                     withOffset: scrollView.contentOffset.y,
                                                     andConstant: 4 * scrollSelectionMultiplier)
                    
                    if playedHaptic != 1 {
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                    }
                    playedHaptic = 1
                }
                    
                    // Share button highlighted
                else if scrollView.contentOffset.y <= -3 * scrollSelectionMultiplier {
                    ScrollSelection.setNormalState(for: safariButton)
                    ScrollSelection.setNormalState(for: backButton)
                    ScrollSelection.setNormalState(for: pinButton)
                    
                    ScrollSelection.setSelectedState(for: shareButton,
                                                     withOffset: scrollView.contentOffset.y,
                                                     andConstant: 3 * scrollSelectionMultiplier)
                    
                    if playedHaptic != 2 {
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                    }
                    playedHaptic = 2
                }
                    
                    // Back button highlighted
                else if scrollView.contentOffset.y <= -2 * scrollSelectionMultiplier {
                    ScrollSelection.setNormalState(for: safariButton)
                    ScrollSelection.setNormalState(for: shareButton)
                    ScrollSelection.setNormalState(for: pinButton)

                    ScrollSelection.setSelectedState(for: backButton,
                                                     withOffset: scrollView.contentOffset.y,
                                                     andConstant: 2 * scrollSelectionMultiplier)
                    
                    if playedHaptic != 3 {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                    
                    playedHaptic = 3
                }
                    
                    // Safari button highlighted
                else if scrollView.contentOffset.y <= -1 * scrollSelectionMultiplier {
                    ScrollSelection.setNormalState(for: backButton)
                    ScrollSelection.setNormalState(for: shareButton)
                    ScrollSelection.setNormalState(for: pinButton)
                    
                    ScrollSelection.setSelectedState(for: safariButton,
                                                     withOffset: scrollView.contentOffset.y,
                                                     andConstant: 1 * scrollSelectionMultiplier)

                    
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
            if !UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.scrollSelection.rawValue) {
                resetScroll()
                if scrollView.contentOffset.y <= -4 * scrollSelectionMultiplier {
                    // Pin button highlighted
                    pinnedItem(scrollView)
                    
                } else if scrollView.contentOffset.y <= -3 * scrollSelectionMultiplier {
                    // Share button highlighted
                    sharePost(scrollView)
                    
                } else if scrollView.contentOffset.y <= -2 * scrollSelectionMultiplier {
                    // Back button highlighted
                    dismiss(scrollView)
                    
                } else if scrollView.contentOffset.y <= -1 * scrollSelectionMultiplier {
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
