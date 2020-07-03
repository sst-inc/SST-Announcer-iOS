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
    
    static func get() -> Timetable? {
        
        let defaults = UserDefaults(suiteName: "group.SST-singapore.Timetables")
        
        guard let jsonStr = defaults?.string(forKey: "TT") else { return nil }
        
        guard let data = jsonStr.data(using: .utf8) else { return nil }
        
        let jsonDecoder = JSONDecoder()
        
        let decodedTimetables = try? jsonDecoder.decode(Timetable.self, from: data)
        
        return decodedTimetables
    }
    
    func save() {
        let defaults = UserDefaults(suiteName: "group.SST-singapore.Timetables")
        
        let jsonEncoder = JSONEncoder()
        
        let encodedTimetable = try! jsonEncoder.encode(self)
        
        let jsonStr = String(data: encodedTimetable, encoding: .utf8)
        
        defaults?.set(jsonStr!, forKey: "TT")
    }
}
