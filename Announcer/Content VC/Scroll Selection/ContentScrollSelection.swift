//
//  ScrollSelection.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension ContentViewController {
    func scrollPin(_ scrollView: UIScrollView) {
        ScrollSelection.setNormalState(for: safariButton)
        ScrollSelection.setNormalState(for: shareButton)

        ScrollSelection.setSelectedState(for: pinButton,
                                         withOffset: scrollView.contentOffset.y,
                                         andConstant: 4 * scrollSelectionMultiplier)

        if playedHaptic != 2 {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        playedHaptic = 2
    }
    
    func scrollShare(_ scrollView: UIScrollView) {
        ScrollSelection.setNormalState(for: safariButton)
        ScrollSelection.setNormalState(for: pinButton)

        ScrollSelection.setSelectedState(for: shareButton,
                                         withOffset: scrollView.contentOffset.y,
                                         andConstant: 3 * scrollSelectionMultiplier)

        if playedHaptic != 3 {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }

        playedHaptic = 3
    }
    
    func scrollSafari(_ scrollView: UIScrollView) {
        ScrollSelection.setNormalState(for: shareButton)
        ScrollSelection.setNormalState(for: pinButton)
        
        ScrollSelection.setSelectedState(for: safariButton,
                                         withOffset: scrollView.contentOffset.y,
                                         andConstant: 1 * scrollSelectionMultiplier)

        if playedHaptic != 4 {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        playedHaptic = 4
    }
    
    // Reset scroll selection by setting borders to 0
    func resetScroll() {
        safariButton.layer.borderWidth = 0
        shareButton.layer.borderWidth = 0
        pinButton.layer.borderWidth = 0
    }
}
