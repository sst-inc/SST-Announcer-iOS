//
//  Labels.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

// Blog URL
// should be https://studentsblog.sst.edu.sg unless testing
#warning("Make sure the blog URL is correct on launch")
let blogURL = "https://studentsblog.sst.edu.sg"

// RSS URL
let rssURL = URL(string: "\(blogURL)/feeds/posts/default")!

// JSON Callback URL
// http://studentsblog.sst.edu.sg/feeds/posts/summary?alt=json&max-results=0&callback=cat
let jsonCallback = URL(string: "http://studentsblog.sst.edu.sg/feeds/posts/summary?alt=json&max-results")!

// JSON Callback to get all the labels for the blog posts
func getLabels() -> [String] {
    do {
        let strData = try String(contentsOf: jsonCallback)
        
        let jsonData = JSON(stringLiteral: strData)
        print(jsonData)
//        print(strData)
    } catch {
        print(error.localizedDescription)
    }
    
    return []
}
