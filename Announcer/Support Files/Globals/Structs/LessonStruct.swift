//
//  LessonStruct.swift
//  Announcer
//
//  Created by JiaChen(: on 21/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

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
    
    // Getting today's date at 00:00
    // This returns the date at midnight
    static func getTodayDate() -> Date {
        // Creating date formatter
        let formatter = DateFormatter()
        
        // Format as yyyy-MM-dd
        // This does not really matter, as long as it contains the year, month and day, it should be fine
        // Also american-style dates are terrible
        formatter.dateFormat = "yyyy-MM-dd"
        
        // Format the current date as that string
        let today = formatter.string(from: Date())
        
        // Get the date from today string. This will return the date at 12 midnight
        return formatter.date(from: today)!
    }
    
    static func convert(time: TimeInterval) -> String {
        // Creating a date from the timeinterval
        let date = Date(timeInterval: time, since: getTodayDate())
        
        // Creating a date formatter
        let format = DateFormatter()
        
        // This date format will produce "12:34pm" from the date given
        format.dateFormat = "H:mma"
        
        // Format the date based on the format above, H:mma -> 12:34pm
        var formattedDate = format.string(from: date).lowercased()
        
        // Split the timings by : to allow for formatting
        var splitTime = formattedDate.split(separator: ":")
        
        // Handling Midnight
        // This ensures that the app can handle it in an unlikely case that a lesson is at midnight
        // This fixes the bug where midnight timings are shown as "0:10am" instead of "12:10am"
        if splitTime.first == "0" {
            // Set the first element to be 12 instead of 0
            splitTime[0] = "12"
            
            // Join it together with : as the separator
            formattedDate = splitTime.joined(separator: ":")
        }
        
        // Remove the 00 in minutes, saves space and makes it look nicer
        // This will make "12:00pm" become "12pm"
        if splitTime.last!.contains("00") {
            // Remove the leading zeros leaving the PM or AM there
            splitTime[1].removeFirst(2)
            
            // Join them without any separator
            formattedDate = splitTime.joined()
        }
        
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
