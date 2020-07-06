//
//  GetLessons.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation

func getOngoingLessons(_ date: Date) -> [WidgetLesson]? {
    
    guard let timetable = Timetable.get() else {
        return nil
    }
    
    
    let lessons = todaysLessons(date, timetable: timetable)
    
    if lessons.count == 0 { return [] }
    
    for i in 0...lessons.count - 1 {
        
        if Lesson.getTodayDate().advanced(by: lessons[i].startTime).distance(to: date) > 0
            && date.distance(to: Lesson.getTodayDate().advanced(by: lessons[i].endTime)) > 0 {
            
            // Generating Widget Lessons
            var widgetLessons: [WidgetLesson] = []
            
            let currentSubject = Assets.subjectIcons[lessons[i].identifier] ?? Assets.subjectIcons["other"]!
            
            widgetLessons.append(WidgetLesson(name: currentSubject[1],
                                              date: Lesson.getTodayDate().advanced(by: lessons[i].endTime),
                                              imageName: currentSubject[0]))
            
            if lessons.count >= i + 2 {
                let firstSubject = Assets.subjectIcons[lessons[i + 1].identifier] ?? Assets.subjectIcons["other"]!
                
                widgetLessons.append(WidgetLesson(name: firstSubject[1],
                                                  date: Lesson.getTodayDate().advanced(by: lessons[i + 1].startTime),
                                                  imageName: firstSubject[0]))
                
                if lessons.count >= i + 3 {
                    let secondSubject = Assets.subjectIcons[lessons[i + 2].identifier] ?? Assets.subjectIcons["other"]!
                    
                    widgetLessons.append(WidgetLesson(name: secondSubject[1],
                                                      date: Lesson.getTodayDate().advanced(by: lessons[i + 2].startTime),
                                                      imageName: secondSubject[0]))
                }
            }
            
            
            
            return widgetLessons
        }
    }
    
    return []
}


func todaysLessons(_ date: Date, timetable: Timetable) -> [Lesson] {
    
    switch Calendar.current.component(.weekday, from: date) {
    case 2:
        return timetable.monday
    case 3:
        return timetable.tuesday
    case 4:
        return timetable.wednesday
    case 5:
        return timetable.thursday
    case 6:
        return timetable.friday
    default:
        return []
    }
}

func getLessonDates(date: Date) -> [Date]? {
    
    guard let timetable = Timetable.get() else {
        return nil
    }
    
    let todayLessons = todaysLessons(date, timetable: timetable)
    
    var lessons = todayLessons.map {
        date.addingTimeInterval($0.startTime)
    }
    
    lessons.append(date.advanced(by: todayLessons.last!.endTime))
    
    lessons = lessons.filter {
        date.distance(to: $0) < 0
    }
    
    return lessons
}
