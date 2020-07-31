//
//  Labels.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

/**
 Struct which stores the identifiers
 
 This struct contains all the identifiers used in the app
 */
struct GlobalIdentifier {
    /// Cell identifier for labels in filterViewController and contentViewController
    static let labelCell                = "labels"
    
    /// Cell identifier for announcements in announcementViewController
    static let announcementCell         = "announcements"
    
    /// Cell identifier for links in contentViewController
    static let linkCell                 = "links"
    
    /// Background Task Identifier
    static let backgroundTask           = Bundle.main.bundleIdentifier! + ".new-announcement"
    
    /// New announcement notification identifier
    static let newNotification          = "new-announcement"
    
    /// Pinned plist used for persistence
    static let pinnedPersistencePlist   = "pinned"
    
    /// Read plist used for persistence
    static let readPersistencePlist     = "read"
    
    /// Identifier for peek and pop for launching post
    static let openPostPreview          = "open post" as NSCopying

    /// Identifier for peek and pop for filters
    static let filterSelection          = "open filter" as NSCopying
    
    /// Identifier for peek and pop for filters
    static let linksSelection           = "open links" as NSCopying
    
    /// Default font size used in the post
    static let defaultFontSize: CGFloat = 15
    
    /// Maximum font size used in the post
    static let maximumFontSize: CGFloat = 50
    
    /// Minimum font size used in the post
    static let minimumFontSize: CGFloat = 5
    
    /// Expansion constant is a constant value added to the width and height
    /// of the button to make the cursor scale in size when hovering over button
    static let expansionConstant: CGFloat = 5
}
