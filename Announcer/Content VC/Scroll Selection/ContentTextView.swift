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
        // Scroll selection
        if !UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.scroll.rawValue) && !I.mac {

            if scrollView.contentOffset.y <= -3 * scrollSelectionMultiplier {
                scrollPin(scrollView)
                
            } else if scrollView.contentOffset.y <= -2 * scrollSelectionMultiplier {
                scrollShare(scrollView)
                
            } else if scrollView.contentOffset.y <= -1 * scrollSelectionMultiplier {
                scrollSafari(scrollView)
                
            }
            // Reset
            else {
                resetScroll()
                playedHaptic = 0
            }
        }
        
        // Hide the links and labels when the user scrolls down
        if scrollView.contentOffset.y > 10 && linksAndLabelStackView.alpha == 1 {

            // Fade the stackView out then hide it to allow the content to take up the full space
            UIView.animate(withDuration: 0.5, animations: {
                self.linksAndLabelStackView.alpha = 0
            }) { (_) in
                UIView.animate(withDuration: 0.3) {
                    self.linksAndLabelStackView.isHidden = true
                }
            }
        } else if scrollView.contentOffset.y <= 10 && linksAndLabelStackView.alpha == 0 {
            // Slowly fade the stackView into view
            
            UIView.animate(withDuration: 0.3, animations: {
                self.linksAndLabelStackView.isHidden = false
            }) { (_) in
                UIView.animate(withDuration: 0.5) {
                    self.linksAndLabelStackView.alpha = 1
                }
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.scroll.rawValue) && !I.mac {
            resetScroll()
            if scrollView.contentOffset.y <= -3 * scrollSelectionMultiplier {
                // Pin button highlighted
                pinnedItem(scrollView)

            } else if scrollView.contentOffset.y <= -2 * scrollSelectionMultiplier {
                // Share button highlighted
                sharePost(scrollView)

            } else if scrollView.contentOffset.y <= -1 * scrollSelectionMultiplier {
                // Safari button highlighted
                openPostInSafari(scrollView)

            }

            resetScroll()
        }
    }
}
