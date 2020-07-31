//
//  Colors.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

/**
 Struct which stores the colors
 
 This struct contains all the colors used in the app
 */
struct GlobalColors {
    /// Blue Tint
    static let blueTint                 = UIColor.systemBlue
    
    /// Border Color for Scroll Selection
    static let borderColor              = blueTint.withAlphaComponent(0.3).cgColor
    
    /// Background color for App
    static let background               = UIColor.systemBackground
    
    /// First Grey Color
    static let greyOne                  = UIColor(named: "Grey 1")!
    
    /// Second Grey Color
    static let greyTwo                  = UIColor(named: "Grey 2")!
    
    /// Third Grey Color
    /// Table View Hover Color
    static let greyThree                = UIColor(named: "Grey 3")!
    
    /// Global Tint
    static let globalTint               = UIColor(named: "Global Tint")!
    
    /// Table View Selection Color
    static let tableViewSelection       = UIColor.systemGray5
    
    /// Table View Selection Hover Color
    static let tableViewSelectionHover  = UIColor.systemGray4
}
