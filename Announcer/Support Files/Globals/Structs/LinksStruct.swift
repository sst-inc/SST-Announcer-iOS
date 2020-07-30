//
//  LinksStruct.swift
//  Announcer
//
//  Created by JiaChen(: on 28/5/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

/**
 Contains attributes for each link such as title, URL and image.
 
 # Usage
 This is an example using SST Inc.'s website
 ```swift
 let site = Links(title: "SST Inc.",
                  link: "https://sstinc.org",
                  UIImage())
 ```
 
 This struct is used to store Links which are to be previewed in the links collectionView in the post.
 This struct contains 3 attributes, the `title`, `link` and `image`.
 Looking back, not a good idea to name it `link` but refractoring is annoying so you'll settle with `link.link`.
 */
struct Links: Equatable, Hashable {
    var title: String
    var link: String
    var image: UIImage?
}
