//
//  Errors.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation

/**
 Error Messages
 
 This struct contains error messages used in the app
 */
struct ErrorMessages {
    // swiftlint:disable line_length
    /// When there is an error launching a post because it requires JavaScript
    static let postRequiresWebKit = Message(title: NSLocalizedString("ALERT_TITLE_WEBKIT",
                                                                     comment: "Title"),
                                            description: NSLocalizedString("ALERT_CONTENT_WEBKIT",
                                                                           comment: "Content"))
    
    /// Error getting posts
    static let unableToLoadPost = Message(title: NSLocalizedString("ALERT_TITLE_INTERNET",
                                                            comment: "Title"),
                                          description: NSLocalizedString("ALERT_CONTENT_INTERNET",
                                                                         comment: "Content"))
    
    /// Error launching post from notifications or spotlight search
    static let unableToLaunchPost = Message(title: NSLocalizedString("ALERT_TITLE_NOTFOUND",
                                                                     comment: "Title"),
                                            description: NSLocalizedString("ALERT_CONTENT_NOTFOUND",
                                                                           comment: "Content"))
    // swiftlint:enable line_length
}

struct Message {
    var title: String
    var description: String
}
