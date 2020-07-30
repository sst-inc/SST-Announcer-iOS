//
//  PostStruct.swift
//  Announcer
//
//  Created by JiaChen(: on 28/5/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation

/**
 Contains attributes for each post such as date, content and title
 
 This struct is used to store Posts.
 The posts stored here will be used in the ReadAnnouncements and the PinnedAnnouncements for persistency.
 It is also used to present each post in the AnnouncementsViewController.
 */
struct Post: Codable, Equatable, Hashable {
    var title: String
    var content: String // This content will be a HTML as a String
    var date: Date
    
    /**
     The following variables are obsolete as they are no longer used in the app.
     
     I can't mark them as obsolete or delete them because it will break persistence on user's devices.
     Therefore, the compromise is marking it as deprecated
     
     - Warning: Do not use these variables; do not edit these variables
     
     ---
     
     ```txt
     Broken if used,
     Broken if deleted,
     Broken if obsoleted,
     Just leave it deprecated
     ```
     
     ```txt
     Once ye delete it,
     Ye shalt forever regret.
     So refrain from it.
     ```
     
     # TL;DR
     Don't use these, don't edit these either
     */
    @available(iOS, deprecated: 13) var pinned: Bool
    @available(iOS, deprecated: 13) var read: Bool
    @available(iOS, deprecated: 13) var reminderDate: Date?
    
    // This variable is below the deprecated bunch because if I move it, it will break something.
    // I want to make it clear, I want to move it, but it will screw up the persistence on users' devices
    var categories: [String]

}
