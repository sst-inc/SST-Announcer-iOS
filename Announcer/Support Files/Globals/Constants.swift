//
//  Labels.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import SystemConfiguration
import UserNotifications
import UIKit
import BackgroundTasks
import SafariServices

struct GlobalLinks {
    /**
     Source URL for the Blog
     
     - important: Ensure that the URL is set to the correct blog before production.
     
     # Production Blog URL
     [http://studentsblog.sst.edu.sg](http://studentsblog.sst.edu.sg)
     
     # Development Blog URL
     [https://testannouncer.blogspot.com](https://testannouncer.blogspot.com)
     
     This constant stores the URL for the blog linked to the RSS feed.
     */
    static let blogURL                  = "http://studentsblog.sst.edu.sg"
    
    /**
     URL for the blogURL's RSS feed
     
     - important: This will only work for blogs created on Blogger.
     
     This URL is the blogURL but with the path of the RSS feed added to the back.
     */
    static let rssURL                   = URL(string: "\(GlobalLinks.blogURL)/feeds/posts/default")!

    /**
     Error 404 website
     
     This URL is to redirect users in a case of an error while getting the blog posts or while attempting to show the student's blog.
     */
    static let errorNotFoundURL         = URL(string: "https://sstinc.org/404")!
    
    /**
     Error 404 website
     
     This URL is to redirect users in a case of an error while getting the blog posts or while attempting to show the student's blog.
     */
    static let settingsURL              = URL(string: "App-Prefs:root=")!
}

/**
 Struct which stores the colors
 
 This struct contains all the colors used in the app
 */
struct GlobalColors {
    /// Blue Tint
    static let blueTint                 = UIColor.systemBlue
    
    /// Border Color for Scroll Selection
    static let borderColor              = GlobalColors.blueTint.withAlphaComponent(0.3).cgColor
    
    /// Background color for App
    static let background               = UIColor(named: "Background")!
    
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

    /// Default font size used in the post
    static let defaultFontSize: CGFloat = 15
}

/**
 Error Messages
 
 This struct contains error messages used in the app
 */
struct ErrorMessages {
    /// When there is an error launching a post because it requires JavaScript
    static let postRequiresWebKit       = Message(title: "Unable to Open Post",
                                                  description: "An error occured when opening this post. Open this post in Safari to view its contents.")
    
    /// Error getting posts
    static let unableToLoadPost         = Message(title: "Check your Internet",
                                                  description: "Unable to fetch data from Students' Blog.\nPlease check your network settings and try again.")
    
    /// Error launching post from notifications or spotlight search
    static let unableToLaunchPost       = Message(title: "Unable to launch post",
                                                  description: "Something went wrong when trying to retrieve the post. You can try to open this post in Safari.")
}

struct Message {
    var title: String
    var description: String
}

/// An enum of UserDefault identifiers
enum UserDefaultsIdentifiers: String {
    // For notifications and Background Fetch
    case recentsTitle                   = "recent-title"
    case recentsContent                 = "recent-content"
    
    // For settings bundle
    case versionNumber                  = "versionNumber"
    case buildNumber                    = "buildNumber"
    
    // For User Interface
    case scrollSelection                = "scrollSelection"
    case textScale                      = "textScale"
}

/// Struct stores all the images used
struct Assets {
    // Post status icons
    static let pin                      = UIImage(systemName: "pin")!
    static let unpin                    = UIImage(systemName: "pin.fill")!
    static let loading                  = UIImage(systemName: "arrow.clockwise")!
    static let error                    = UIImage(systemName: "exclamationmark.triangle.fill")!
    static let unread                   = UIImage(systemName: "circle.fill")!
    
    // Link Icons
    static let mail                     = UIImage(systemName: "envelope.circle.fill")!
    static let docs                     = UIImage(systemName: "envelope.circle.fill")!
    static let folder                   = UIImage(systemName: "folder.circle.fill")!
    static let call                     = UIImage(systemName: "phone.circle.fill")!
    static let socialMedia              = UIImage(systemName: "person.crop.circle.fill")!
    static let video                    = UIImage(systemName: "film.fill")!
    static let photo                    = UIImage(systemName: "photo.fill")!
    static let defaultLinkIcon          = UIImage(systemName: "link.circle.fill")!
    
    // Preview icons
    static let share                    = UIImage(systemName: "square.and.arrow.up")!
    static let open                     = UIImage(systemName: "envelope.open")!
    
    // Header icons
    static let filter                   = UIImage(systemName: "line.horizontal.3.decrease.circle")
    static let filterFill               = UIImage(systemName: "line.horizontal.3.decrease.circle.fill")
    static let safari                   = UIImage(systemName: "safari")
    static let settings                 = UIImage(systemName: "gear")
}

struct Storyboards {
    static let main                     = UIStoryboard(name: "Main", bundle: .main)
    static let filter                   = UIStoryboard(name: "Filter", bundle: .main)
    static let content                  = UIStoryboard(name: "Content", bundle: .main)
}
