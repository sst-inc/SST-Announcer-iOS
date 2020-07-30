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
    /**
     Max amount of read posts
     Ensures that it does not get too huge
     */
    static let maxPosts = 40
    
    /**
     Gets archive URL for Read Announcements
     
     - returns: The archive URL to store read announcements
     
     This method gets the .plist URL to save the read announcements to.
     */
    static func getArchiveURL() -> URL {
        let plistName = GlobalIdentifier.readPersistencePlist
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
    }
    
    /**
     Writes the read announcements to the plist
     
     - parameters:
        - posts: An array of read announcements
     
     This method converts the posts into a property list and saves them into the local file.
     */
    static func saveToFile(posts: [Post]) {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        
        // Remove duplicated posts to keep the READ items short
        var postsRemovedDuplicates = { () -> [Post] in
            var mutablePosts = posts
            mutablePosts.removeDuplicates()
            
            return mutablePosts
        }()
        
        // Limit the read array to the latest 20 otherwise the plist
        // will get ridiculously huge and store a bunch of old, unnecessary data
        if postsRemovedDuplicates.count > maxPosts {
            postsRemovedDuplicates.removeFirst(postsRemovedDuplicates.count - maxPosts)
        }
        
        let encodedPosts = try? propertyListEncoder.encode(postsRemovedDuplicates)
        try? encodedPosts?.write(to: archiveURL, options: .noFileProtection)
    }
    
    /**
     Reads the read announcements from the plist
     
     - returns: An array of read announcements
     
     This method gets the posts that have been read from the local property list.
    */
    static func loadFromFile() -> [Post]? {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedPostData = try? Data(contentsOf: archiveURL) else { return nil }
        guard let decodedPost = try? propertyListDecoder.decode(Array<Post>.self,
                                                                from: retrievedPostData) else { return nil }
        
        return decodedPost
    }
}
