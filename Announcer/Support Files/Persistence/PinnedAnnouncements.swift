//
//  PinnedAnnouncements.swift
//  Announcer
//
//  Created by JiaChen(: on 28/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import UIKit

class PinnedAnnouncements: Codable {
    /**
     Gets archive URL for Pinned Announcements
     
     - returns: The archive URL to store pinned announcements
     
     This method gets the .plist URL to save the pinned announcements to.
     */
    static func getArchiveURL() -> URL {
        let plistName = GlobalIdentifier.pinnedPersistencePlist
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
    }
    
    /**
     Writes the pinned announcements to the plist
     
     - parameters:
        - posts: An array of pinned announcements
     
     This method converts the posts into a property list and saves them into the local file.
    */
    static func saveToFile(posts: [Post]) {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedPosts = try? propertyListEncoder.encode(posts)
        try? encodedPosts?.write(to: archiveURL, options: .noFileProtection)
    }
    
    /**
     Reads the pinned announcements from the plist
     
     - returns: An array of pinned announcements
     
     This method gets the posts that have been pinned from the local property list.
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
