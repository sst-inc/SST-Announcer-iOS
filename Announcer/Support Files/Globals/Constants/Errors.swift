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
    static let postRequiresWebKit       = Message(title: "Unable to Open Post",
                                                  description: "An error occured when opening this post. Open this post in Safari to view its contents.")
    
    /// Error getting posts
    static let unableToLoadPost         = Message(title: "Check your Internet",
                                                  description: "Unable to fetch data from Students' Blog.\nPlease check your network settings and try again.")
    
    /// Error launching post from notifications or spotlight search
    static let unableToLaunchPost       = Message(title: "Unable to launch post",
                                                  description: "Something went wrong when trying to retrieve the post. You can try to open this post in Safari.")
    // swiftlint:enable line_length
}

struct Message {
    var title: String
    var description: String
}
