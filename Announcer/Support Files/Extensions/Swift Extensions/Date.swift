//
//  Date.swift
//  Announcer
//
//  Created by JiaChen(: on 5/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation

extension Date {
    func day() -> String {
        let day = Calendar.current.component(.weekday, from: self)
        
        let days = Calendar.current.weekdaySymbols
        
        return days[day - 1]
    }
}
