//
//  AnnouncementWidget.swift
//  Announcer
//
//  Created by JiaChen(: on 10/8/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

struct Announcement: Codable, Equatable {
    var title: String
    var publishDate: Date
    var imageIdentifiers: [String]
    
    var formattedDate: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = NSLocalizedString("DATE_FORMAT",
                                                 comment: "6 Aug 2020")
        
        return formatter.string(from: publishDate)
    }
    
    static func == (lhs: Announcement, rhs: Announcement) -> Bool {
        return lhs.imageIdentifiers == rhs.imageIdentifiers && lhs.title == rhs.title
    }
    
    static func get() -> [Announcement]? {
        
        let defaults = UserDefaults(suiteName: "group.SST-singapore.Timetables")
        
        guard let jsonStr = defaults?.string(forKey: "announcements") else { return nil }
        
        guard let data = jsonStr.data(using: .utf8) else { return nil }
        
        let jsonDecoder = JSONDecoder()
        
        let decodedAnnouncements = try? jsonDecoder.decode([Announcement].self, from: data)
        
        return decodedAnnouncements
    }
    
    static func save(_ announcements: [Announcement]) {
        let defaults = UserDefaults(suiteName: "group.SST-singapore.Timetables")
        
        let jsonEncoder = JSONEncoder()
        
        if let encodedAnnouncements = try? jsonEncoder.encode(announcements) {
            let jsonStr = String(data: encodedAnnouncements, encoding: .utf8)
            
            defaults?.set(jsonStr!, forKey: "announcements")
        }
    }
    
    func getLink() -> String {
        title.lowercased().replacingOccurrences(of: " ", with: "%20").filter {
            $0.isASCII && !$0.isNewline
        }
    }
}
