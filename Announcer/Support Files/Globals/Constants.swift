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

/**
Checking platform, this handles iOS 13 and 14.

# Check if user is on MacOS
```swift
if I.mac {
    // run code just for Mac
}
```

# Check if user is on iPadOS
```swift
if I.wantToBeMac {
    // run code just for iPad
}
```

# Check if user is on iOS
```swift
if I.Phone {
    // run code just for iPhone
}
```

# Better way to crash
Let's be real, this is the best way to terminate a program
```swift
I.wantToDie
```
*/
struct I {
    /// Check if device is a Mac
    static let mac: Bool = {
        if #available(iOS 14.0, *) {
            return UIDevice.current.userInterfaceIdiom == .mac
        } else {
            #if targetEnvironment(macCatalyst)
            return true
            #endif
            return false
        }
    }()
    
    /// Check if device is an iPad
    static let wantToBeMac: Bool = {
        #if targetEnvironment(macCatalyst)
        return false
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
        #endif
    }()
    
    /// Check if device is an iPhone
    static let phone: Bool = {
        UIDevice.current.userInterfaceIdiom == .phone
    }()
    
    /// I want to die
    static var wantToDie: Never {
        fatalError()
    }
}

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
    
    /// Expansion constant is a constant value added to the width and height of the button to make the cursor scale in size when hovering over button
    static let expansionConstant: CGFloat = 5
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
    static let readingList              = UIImage(systemName: "eyeglasses")!
    static let copy                     = UIImage(systemName: "doc.on.doc")!
    
    // Header icons
    static let filter                   = UIImage(systemName: "line.horizontal.3.decrease.circle")!
    static let filterFill               = UIImage(systemName: "line.horizontal.3.decrease.circle.fill")!
    static let safari                   = UIImage(systemName: "safari")!
    static let settings                 = UIImage(systemName: "gear")!
    
    // Zooming Icon
    static let zoomIn                   = UIImage(systemName: "plus.magnifyingglass")!
    static let zoomOut                  = UIImage(systemName: "minus.magnifyingglass")!
    static let resetZoom                = UIImage(systemName: "1.magnifyingglass")!
    
    static let checkmark                = UIImage(systemName: "checkmark")!
    static let cross                    = UIImage(systemName: "xmark")!
    static let home                     = UIImage(systemName: "house")!
    
    // Subject icons
    // Key: Subject Name, Item: image
    @available(iOS 14, macOS 11, *)
    static func getSubject(_ identifier: String, font: UIFont) -> (UIImage, String) {
        let day = Calendar.current.component(.weekday, from: Date()) == 1 ? "Sunday" : "Saturday"
        
        let subjectIcons = ["el"       : ["a.book.closed", "English"],                      // 􀫕
                            "math"     : ["x.squareroot", "Math"],                          // 􀓪
                            "s&w"      : ["sportscourt", "S&W"],                            // 􀝐
                            "hum"      : ["person", "Humanities"],                          // 􀉩
                            "sci"      : ["thermometer", "Science"],                        // 􀇬
                           
                            // Mother tongue
                            "cl"       : ["globe", "Mother Tongue"],                        // 􀆪
                            "ml"       : ["globe", "Mother Tongue"],                        // 􀆪
                            "tl"       : ["globe", "Mother Tongue"],                        // 􀆪
                           
                            // Changemakers
                            "cm(ict)"  : ["swift", "ICT"],                                  // 􀫊
                            "cm(ps)"   : ["mic", "Presentation Skills"],                    // 􀊰
                            "cm(admt)" : ["scribble", "ADMT"],                              // 􀓨
                            "i&e"      : ["paperplane", "I&E"],                             // 􀈟
                            "cm lesson": ["lightbulb", "Changemakers"],                     // 􀛭
                           
                            // Applied Subjects
                            "comp"     : ["cpu", "Computing"],                              // 􀫥
                            "elec"     : ["bolt.fill.batteryblock", "Electronics"],         // 􀫮
                            "design"   : ["paintpalette", "Design Studies"],                // 􀝥
                            "biotech"  : ["leaf", "Biotech"],                               // 􀥲
                            
                            // Humanities
                            "ch(ge)"   : ["mappin.and.ellipse", "Geography"],               // 􀎫
                            "ch(he)"   : ["clock", "History"],                              // 􀐫
                            "ss"       : ["building.columns", "Social Studies"],            // 􀤨
                           
                            // Science
                            "bio"      : ["hare", "Biology"],                               // 􀓎
                            "phy"      : ["scalemass", "Physics"],                          // 􀭭
                            "chem"     : ["atom", "Chemistry"],                             // 􀬚
                           
                            // Others
                            "break"    : ["zzz", "Break"],                                  // 􀖃
                            "adv/assb" : ["face.similing", "adv/assb"],                     // 􀎸
                            "cce"      : ["face.similing", "CCE"],                          // 􀎸
                            "other"    : ["studentdesk", identifier],                       // 􀑔
             
                            // Special state icons
                            "|weekend|": ["calendar", "It's \(day)!"],                      // 􀉉
                            "|before|" : ["clock", "Starting Soon"],                        // 􀐫
                            "|over|"   : ["Class Dismissed!", "house"]                      // 􀎞
        ]
        
        let subject = subjectIcons[identifier] ?? subjectIcons["other"]!
        let icon = UIImage(systemName: subject[0], withConfiguration: UIImage.SymbolConfiguration(font: font))!
        
        return (icon, subject[1])
    }
}

struct Storyboards {
    static let main                     = UIStoryboard(name: "Main", bundle: .main)
    static let filter                   = UIStoryboard(name: "Filter", bundle: .main)
    static let content                  = UIStoryboard(name: "Content", bundle: .main)
    static let timetable                = UIStoryboard(name: "Timetable", bundle: .main)

}
