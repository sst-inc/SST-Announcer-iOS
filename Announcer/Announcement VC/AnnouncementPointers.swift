//
//  AnnouncementPointers.swift
//  Announcer
//
//  Created by JiaChen(: on 5/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.4, *)
extension AnnouncementsViewController: UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        if interaction.view is UIButton {
            
            let frame = CGRect(x: 0, y: 0, width: interaction.view!.frame.width + 5, height: interaction.view!.frame.height + 5)
            
            return .init(shape: UIPointerShape.roundedRect(frame, radius: 20))
        }
        
        return nil
    }
    
    func pointerInteraction(_ interaction: UIPointerInteraction, willExit region: UIPointerRegion, animator: UIPointerInteractionAnimating) {
        
    }
    
    func pointerInteraction(_ interaction: UIPointerInteraction, willEnter region: UIPointerRegion, animator: UIPointerInteractionAnimating) {
        
    }
    
    func pointerInteraction(_ interaction: UIPointerInteraction, regionFor request: UIPointerRegionRequest, defaultRegion: UIPointerRegion) -> UIPointerRegion? {
        var pointerRegion: UIPointerRegion? = nil
        
        if let view = interaction.view as? UIButton {
            pointerRegion = UIPointerRegion(rect: view.bounds,
                                            identifier: "pointer identifier")
        }
        
        return pointerRegion
    }
}
