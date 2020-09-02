//
//  Links.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

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
     
     This URL is to redirect users in a case of an error while
     getting the blog posts or while attempting to show the student's blog.
     */
    static let errorNotFoundURL         = URL(string: "https://sstinc.org/404")!
    
    /**
     Error 404 website
     
     This URL is to redirect users in a case of an error while
     getting the blog posts or while attempting to show the student's blog.
     */
    static let settingsURL              = URL(string: "App-Prefs:root=")!
    
    static let sstinc                   = URL(string: "https://sstinc.org/")!

}
