//
//  ReadAnnouncements.swift
//  Announcer
//
//  Created by JiaChen(: on 28/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import UIKit

class ReadAnnouncements: Codable {
    static func getArchiveURL() -> URL {
        let plistName = "read"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
    }
    
    static func saveToFile(posts: [Post]) {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedPosts = try? propertyListEncoder.encode(posts)
        try? encodedPosts?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Post]? {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedPostData = try? Data(contentsOf: archiveURL) else { return nil }
        guard let decodedPost = try? propertyListDecoder.decode(Array<Post>.self, from: retrievedPostData) else { return nil }
        
        return decodedPost
    }
}

