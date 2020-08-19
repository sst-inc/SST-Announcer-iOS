//
//  Search.swift
//  Announcer
//
//  Created by JiaChen(: on 19/8/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation

struct AnnouncementSearch {
    var titles: [Post]?
    var contents: [Post]?
    var labels: [Post]? {
        didSet {
            labelsDidSet()
        }
    }
    
    var labelsDidSet: (() -> Void)
}
