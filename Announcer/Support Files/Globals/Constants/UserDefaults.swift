//
//  UserDefaults.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation

/// An enum of UserDefault identifiers
enum UserDefaultsIdentifiers: String {
    // For notifications and Background Fetch
    case recentsTitle                   = "recent-title"
    case recentsContent                 = "recent-content"
    
    // For settings bundle
    case versionNumber                  = "versionNumber"
    case buildNumber                    = "buildNumber"
    
    // For User Interface
    case scroll                         = "scrollSelection"
    case textScale                      = "textScale"
}
