//
//  TimetableStruct.swift
//  Announcer
//
//  Created by JiaChen(: on 14/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

struct Timetable: Equatable, Codable {
    static let frameMultiplier = 3
    
    var `class`: String
    var timetableImage: Data
    
    var monday: [Lesson]
    var tuesday: [Lesson]
    var wednesday: [Lesson]
    var thursday: [Lesson]
    var friday: [Lesson]
    
    

    
    static func convert(with image: UIImage) -> Data {
        return image.pngData()!
    }
    
    static func convert(with data: Data) -> UIImage {
        return UIImage(data: data)!
    }
}

struct Lesson: Equatable, Codable {
    /// Lesson identifier is linked to the icons and full names in `Constants.swift`
    var identifier: String
    
    var teacher: String?
    
    // Setting the times of lessons
    // When the time is zero, it represents midnight
    // The timings are all in seconds
    
    /// Start Time of lesson
    var startTime: TimeInterval
    
    /// End Time of lesson
    var endTime: TimeInterval
    
    static let todayDate = { () -> Date in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        return formatter.date(from: today)!
    }()
    
    static func convert(time: TimeInterval) -> String {
        let date = Date(timeInterval: time, since: todayDate)
        
        let format = DateFormatter()
        format.dateFormat = "H:mma"
        
        let formattedDate = format.string(from: date).lowercased()
        
        return formattedDate
    }
    
    /// Converting Hours to TimeIntervals
    static func convert(hours: Double) -> TimeInterval {
        return convert(minutes: hours * 60)
    }
    
    /// Converting Minutes to TimeIntervals
    static func convert(minutes: Double) -> TimeInterval {
        return minutes * 60
    }
}
