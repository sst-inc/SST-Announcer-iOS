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
 
 This struct is used to store Posts. The posts stored here will be used in the ReadAnnouncements and the PinnedAnnouncements for persistency. It is also used to present each post in the AnnouncementsViewController.
 */
struct Post: Codable, Equatable {
    var title: String
    var content: String // This content will be a HTML as a String
    var date: Date
    
    var pinned: Bool
    var read: Bool
    var reminderDate: Date?
    
    var categories: [String]
}
