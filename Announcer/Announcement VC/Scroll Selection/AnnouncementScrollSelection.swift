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
    func scrollTimetable(_ scrollView: UIScrollView) {
        ScrollSelection.setNormalState(for: filterButton)
        ScrollSelection.setNormalState(for: searchField)
        ScrollSelection.setNormalState(barButton: reloadButton)
        
        ScrollSelection.setSelectedState(barButton: timetableButton,
                                         withOffset: scrollView.contentOffset.y,
                                         andConstant: 4 * scrollSelectionMultiplier)
        
        if playedHaptic != 4 {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        playedHaptic = 4
    }
    
    func scrollReload(_ scrollView: UIScrollView) {
        ScrollSelection.setNormalState(for: filterButton)
        ScrollSelection.setNormalState(for: searchField)
        ScrollSelection.setNormalState(barButton: timetableButton)
        
        ScrollSelection.setSelectedState(barButton: reloadButton!,
                                         withOffset: scrollView.contentOffset.y,
                                         andConstant: 3 * scrollSelectionMultiplier)
        
        if playedHaptic != 1 {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        playedHaptic = 1
    }

    func scrollFilter(_ scrollView: UIScrollView) {
        ScrollSelection.setNormalState(for: searchField)
        ScrollSelection.setNormalState(barButton: reloadButton)
        ScrollSelection.setNormalState(barButton: timetableButton)
        
        ScrollSelection.setSelectedState(for: filterButton,
                                         withOffset: scrollView.contentOffset.y,
                                         andConstant: 2 * scrollSelectionMultiplier)
        
        if playedHaptic != 2 {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
        playedHaptic = 2
    }

    func scrollSearch(_ scrollView: UIScrollView) {
        ScrollSelection.setNormalState(for: filterButton)
        ScrollSelection.setNormalState(barButton: reloadButton)
        ScrollSelection.setNormalState(barButton: timetableButton)
        
        ScrollSelection.setSelectedState(for: searchField,
                                         withOffset: scrollView.contentOffset.y,
                                         andConstant: scrollSelectionMultiplier)
        
        if playedHaptic != 3 {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        playedHaptic = 3
    }
    
    func resetScroll() {
        ScrollSelection.setNormalState(barButton: reloadButton)
        ScrollSelection.setNormalState(barButton: timetableButton)
        ScrollSelection.setNormalState(for: searchField)
        ScrollSelection.setNormalState(for: filterButton)
    }
}
