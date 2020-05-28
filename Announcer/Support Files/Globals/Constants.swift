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
    static let blogURL = "http://studentsblog.sst.edu.sg"
    
    /**
     URL for the blogURL's RSS feed
     
     - important: This will only work for blogs created on Blogger.
     
     This URL is the blogURL but with the path of the RSS feed added to the back.
     */
    static let rssURL = URL(string: "\(GlobalLinks.blogURL)/feeds/posts/default")!

    /**
     Error 404 website
     
     This URL is to redirect users in a case of an error while getting the blog posts or while attempting to show the student's blog.
     */
    static let errorNotFoundURL = URL(string: "https://sstinc.org/404")!
}

/**
 Struct which stores the colors
 
 This struct contains all the colors used in the app
 */
struct GlobalColors {
    /// Border Color for Scroll Selection
    static let borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
    
    /// Background color for App
    static let background = UIColor(named: "background")!
    
    /// First Grey Color
    static let greyOne = UIColor(named: "Grey 1")!
    
    /// Second Grey Color
    static let greyTwo = UIColor(named: "Grey 2")!
    
    /// Global Tint
    static let globalTint = UIColor(named: "Global Tint")!
}
