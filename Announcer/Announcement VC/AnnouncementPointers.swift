//
//  AnnouncementPointers.swift
//  Announcer
//
//  Created by JiaChen(: on 5/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.4, macOS 11, *)
extension AnnouncementsViewController: UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        
        // Handling when it is a button
        // basically those header buttons
        if interaction.view is UIButton {
            
            // Create a new frame, which is a little larger than the normal
            let frame = CGRect(x: 0,
                               y: 0,
                               width: interaction.view!.frame.width + GlobalIdentifier.expansionConstant,
                               height: interaction.view!.frame.height + GlobalIdentifier.expansionConstant)
            
            return .init(shape: UIPointerShape.roundedRect(frame, radius: 20))
        }
        
        return nil
    }
    
    func pointerInteraction(_ interaction: UIPointerInteraction, regionFor request: UIPointerRegionRequest, defaultRegion: UIPointerRegion) -> UIPointerRegion? {
        var pointerRegion: UIPointerRegion? = nil
        
        if let view = interaction.view as? UIButton {
            // Handling UIButton (those header buttons)
            pointerRegion = UIPointerRegion(rect: view.bounds,
                                            identifier: "pointer identifier")
        }
        
        return pointerRegion
    }
}
