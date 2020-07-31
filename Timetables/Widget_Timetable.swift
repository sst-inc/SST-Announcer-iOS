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
                         completion: @escaping (WidgetEntry) -> Void) {
        let entry = WidgetEntry(date: Date())
 
        completion(entry)
    }

    public func timeline(with context: Context,
                         completion: @escaping (Timeline<Entry>) -> Void) {

        var items: [WidgetEntry] = []

        if !Calendar.current.isDateInWeekend(Date()) {
            if let lessonDates = getLessonDates(date: Date()) {
                items = lessonDates.map {
                    // Keep it relevant for 10 minutes
                    WidgetEntry(date: $0, relevance: TimelineEntryRelevance(score: 100, duration: 600))
                }
            } else {
                items = [WidgetEntry(date: Date(),
                                     relevance: TimelineEntryRelevance(score: 0, duration: 0)),
                         WidgetEntry(date: Date(),
                                     relevance: TimelineEntryRelevance(score: 0, duration: 0))]
            }
        }
        
        // Ensure smart stacks will not show Announcer widgets on weekends and at midnight
        items.append(WidgetEntry(date: Lesson.getTodayDate().advanced(by: 86400),
                                 relevance: TimelineEntryRelevance(score: 0, duration: 0)))
        
        // Reload right now to get the latest data
        // Just make it relevant for the next 10 minutes... as a safe guard
        items.append(WidgetEntry(date: Date(),
                                 relevance: TimelineEntryRelevance(score: 100, duration: 600)))
        
        let timeline = Timeline(entries: items, policy: .atEnd)
        
        completion(timeline)
    }
}

public struct WidgetEntry: TimelineEntry {
    public let date: Date
    public var relevance: TimelineEntryRelevance?
}

// Create a placeholder view to show
struct PlaceholderView: View {
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ViewBuilder
    var body: some View {
        Screens.Placeholder(family: family)
    }
}

struct WidgetTimetableEntryView: View {
    var entry: Provider.Entry
    
    private let announcerURL = URL(string: "sstannouncer://")!
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ViewBuilder
    var body: some View {
        
        // Getting current lesson
        if var lessons: [WidgetLesson] = getOngoingLessons(entry.date) {
            
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
                
                Screens.Default(family: family,
                                currentLesson: currentLesson,
                                firstNextLesson: firstNextLesson,
                                secondNextLesson: secondNextLesson)
                    .widgetURL(announcerURL)
                
            } else {
                if Calendar.current.isDateInWeekend(entry.date) {
                    Screens.WeekendView(family: family)
                        .widgetURL(announcerURL)
                } else {
                    Screens.NoLessonsView(family: family)
                        .widgetURL(announcerURL)
                }
            }
        } else {
            // User has not set up
            Screens.NotSetUp(family: family)
                .widgetURL(announcerURL)
        }
    }
}

@main
struct WidgetTimetable: Widget {

    // Bundle ID
    private let kind: String = "sg.edu.sst.panziyue.Announcer.Timetable"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider()) { entry in
            WidgetTimetableEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Timetables")
        .description("Keep track of your lessons and find out what's next.")
    }
}

struct WidgetTimetablePreviews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetTimetableEntryView(entry: WidgetEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
