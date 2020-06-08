//
//  ContentPointer.swift
//  Announcer
//
//  Created by JiaChen(: on 5/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

// For iPadOS 13.4 and up, pointer support
@available(iOS 13.4, *)
extension ContentViewController: UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        // If the view is a button, create interaction frame to be a little larger
        if interaction.view is UIButton {
            let frame = CGRect(x: 0, y: 0, width: interaction.view!.frame.width + 5, height: interaction.view!.frame.height + 5)
            
            // Round corners of selection
            return .init(shape: UIPointerShape.roundedRect(frame, radius: 30))
            
        } else if interaction.view is UICollectionViewCell {
            
            return .init(effect: UIPointerEffect.lift(UITargetedPreview(view: interaction.view!)))
        }

        
        return nil
    }
    
    func pointerInteraction(_ interaction: UIPointerInteraction, regionFor request: UIPointerRegionRequest, defaultRegion: UIPointerRegion) -> UIPointerRegion? {
        var pointerRegion: UIPointerRegion? = nil
        
        if let view = interaction.view as? UIButton {
            // Handling scroll selection buttons
            pointerRegion = UIPointerRegion(rect: view.bounds,
                                            identifier: "pointer identifier")
        } else if let view = interaction.view as? UICollectionViewCell {
            // Handling labels & links collection view cell
            pointerRegion = UIPointerRegion(rect: view.bounds,
                                            identifier: "selectedView")
        }
        
        return pointerRegion
    }
}
