//
//  AnnouncementScrollSelection.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension AnnouncementsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if I.wantToBeMac || I.mac {
            // Dismiss keyboard at for iPads because they do not auto dismiss
            view.endEditing(true)
        }
        
        // Opening and closing feedback reporting button
        if scrollView.contentOffset.y > 25 {
            feedback.close()
        } else {
            feedback.open()
        }
        
        let defaultsScrollSelection = UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.scroll.rawValue)
        
        if !searchField.isFirstResponder && !defaultsScrollSelection && !I.mac {
            if #available(iOS 14, *), scrollView.contentOffset.y <= -4 * scrollSelectionMultiplier {
                
                scrollTimetable(scrollView)
            } else if scrollView.contentOffset.y <= -3 * scrollSelectionMultiplier {
                
                scrollReload(scrollView)
            } else if scrollView.contentOffset.y <= -2 * scrollSelectionMultiplier {
                scrollFilter(scrollView)
            } else if scrollView.contentOffset.y <= -1 * scrollSelectionMultiplier {
                scrollSearch(scrollView)
            } else {
                resetScroll()
                playedHaptic = 0
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        #if targetEnvironment(macCatalyst)
        // Disabled scroll selection on mac catalyst
        #else
            if !UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.scroll.rawValue) {
                resetScroll()
                
                // This only works after iOS 14
                if #available(iOS 14, *), scrollView.contentOffset.y <= -4 * scrollSelectionMultiplier {
                    // Open up timetable
                    openTimetable(UILabel())
                    
                } else if scrollView.contentOffset.y <= -3 * scrollSelectionMultiplier {
                    // Reload view
                    reload(UILabel())
                    
                } else if scrollView.contentOffset.y <= -2 * scrollSelectionMultiplier {
                    // Show labels selection screen
                    sortWithLabels(UILabel())
                    
                } else if scrollView.contentOffset.y <= -1 * scrollSelectionMultiplier {
                    if I.wantToBeMac || I.mac {
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                            // Select search field
                            self.searchField.becomeFirstResponder()
                            
                            // Reset search field style
                            ScrollSelection.setNormalState(for: self.searchField)
                        }
                    } else {
                        // Select search field
                        searchField.becomeFirstResponder()
                        
                        // Reset search field style
                        ScrollSelection.setNormalState(for: searchField)
                    }
                }
                
                filterButton.tintColor = GlobalColors.greyOne
                searchField.alpha = 1
                reloadButton.tintColor = GlobalColors.greyOne
                
                resetScroll()
            }
        #endif
    }
}
