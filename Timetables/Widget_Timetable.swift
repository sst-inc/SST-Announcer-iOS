//
//  Widget_Timetable.swift
//  Widget Timetable
//
//  Created by JiaChen(: on 23/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import WidgetKit
import SwiftUI

public struct Provider: TimelineProvider {
    
    public func snapshot(with context: Context,
                         completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date())
        
        completion(entry)
    }
    
    public func timeline(with context: Context,
                         completion: @escaping (Timeline<Entry>) -> ()) {
        
        var items: [WidgetEntry] = []
        
        if !Calendar.current.isDateInWeekend(Date()) {
            items = getLessonDates(date: Date()).map {
                WidgetEntry(date: $0)
            }
        }
        
        items.append(WidgetEntry(date: Lesson.getTodayDate().advanced(by: 86400)))
        
        // Reload right now to get the latest data
        items.append(WidgetEntry(date: Date()))
        
        let timeline = Timeline(entries: items, policy: .atEnd)
        
        completion(timeline)
    }
}

public struct WidgetLesson {
    public var name: String
    public var date: Date
    public var imageName: String
}

public struct WidgetEntry: TimelineEntry {
    public let date: Date
}

// Create a placeholder view to show
struct PlaceholderView : View {
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(
                            width: 40,
                            height: 40
                        )
                }
                Rectangle()
                    .fill(Color.secondary)
                    .cornerRadius(6)
                    .frame(width: 100,
                           height: 20)
                Rectangle()
                    .fill(Color.secondary)
                    .cornerRadius(4)
                    .frame(width: 80,
                           height: 10)
                Rectangle()
                    .fill(Color.secondary)
                    .cornerRadius(4)
                    .frame(width: 60,
                           height: 10)
            }
            .padding(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        case .systemMedium:
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(
                                    width: 30,
                                    height: 30
                                )
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(6)
                                .frame(width: 100,
                                       height: 20)
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(4)
                                .frame(width: 100,
                                       height: 10)
                        }
                    }
                }.padding([.leading, .trailing, .top])
                
                VStack(alignment: .leading) {
                    Text("Next:")
                        .font(
                            Font
                                .system(
                                    size: 16,
                                    weight: .bold,
                                    design: .default
                                )
                        )
                        .foregroundColor(
                            .blue
                        )
                        .padding([.leading, .trailing, .top])
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(6)
                                .frame(width: 100,
                                       height: 20)
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(4)
                                .frame(width: 100,
                                       height: 10)
                        }
                        .padding([.leading, .trailing])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Rectangle()
                            .fill(Color.secondary)
                            .frame(
                                width: 1
                            )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(6)
                                .frame(width: 100,
                                       height: 20)
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(4)
                                .frame(width: 100,
                                       height: 10)
                        }
                        .padding([.leading, .trailing])
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    }
                    .frame(
                        maxWidth:
                            .infinity,
                        maxHeight:
                            .infinity,
                        alignment:
                            .leading)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Grey 3"))
                .cornerRadius(10, antialiased: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
        default:
            I.wantToDie
        }
    }
}

struct Widget_TimetableEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ViewBuilder
    var body: some View {
        
        // Getting current lesson
        var lessons: [WidgetLesson] = getOngoingLessons(entry.date)
        let currentLesson: WidgetLesson? = lessons.first

        if let currentLesson = currentLesson {
            
            let firstNextLesson: WidgetLesson? = {
                lessons.removeFirst()
                return lessons.first
            }()
            let secondNextLesson: WidgetLesson? = {
                if firstNextLesson != nil {
                    lessons.removeFirst()
                    
                    return lessons.first
                }
                return nil
            }()
            
            switch family {
            case .systemSmall:
                WidgetComponents.Small(currentLesson: currentLesson, firstNextLesson: firstNextLesson)
            case .systemMedium:
                WidgetComponents.Medium(currentLesson: currentLesson, firstNextLesson: firstNextLesson, secondNextLesson: secondNextLesson)
            default: I.wantToDie
            }
        } else {
            if Calendar.current.isDateInWeekend(entry.date) {
                WidgetComponents.WeekendView(family: family)
            } else {
                WidgetComponents.NoLessonsView(family: family)
            }
            
        }
    }
}

@main
struct Widget_Timetable: Widget {
    
    // Bundle ID
    private let kind: String = "sg.edu.sst.panziyue.Announcer.Timetable"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider(),
                            placeholder: PlaceholderView()) { entry in
            Widget_TimetableEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Timetables")
        .description("Keep track of your lessons and find out what's next.")
    }
}

func getOngoingLessons(_ date: Date) -> [WidgetLesson] {
    
    guard let timetable = Timetable.get() else {
        return []
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

func getLessonDates(date: Date) -> [Date] {
    
    guard let timetable = Timetable.get() else {
        return []
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

struct WidgetTimetable_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Widget_TimetableEntryView(entry: WidgetEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
