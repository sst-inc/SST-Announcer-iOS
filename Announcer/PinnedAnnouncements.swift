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
    static func getArchiveURL() -> URL {
        let plistName = "pinned"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
    }
    
    static func saveToFile(posts: [Post]) {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedExpenditures = try? propertyListEncoder.encode(posts)
        try? encodedExpenditures?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Post]? {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedExpenditureData = try? Data(contentsOf: archiveURL) else { return nil }
        guard let decodedExpenditure = try? propertyListDecoder.decode(Array<Post>.self, from: retrievedExpenditureData) else { return nil }
        
        return decodedExpenditure
    }
}

