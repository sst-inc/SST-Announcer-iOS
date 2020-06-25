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
                         completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                currentLesson: WidgetLesson(name: "Computing", date: Date(), imageName: "cpu"),
                                lessonTime: Date(),
                                nextLessons: [WidgetLesson(name: "Chemistry", date: Date(), imageName: "flame"),
                                              WidgetLesson(name: "Biology", date: Date(), imageName: "hare")])
        
        completion(entry)
    }
    
    public func timeline(with context: Context,
                         completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                currentLesson: WidgetLesson(name: "Computing", date: Date(), imageName: "cpu"),
                                lessonTime: Date(),
                                nextLessons: [WidgetLesson(name: "Chemistry", date: Date(), imageName: "flame"),
                                              WidgetLesson(name: "Biology", date: Date(), imageName: "hare")])
        
        let timeline = Timeline(entries: [entry, entry], policy: .atEnd)
        completion(timeline)
    }
}

public struct WidgetLesson {
    public var name: String
    public var date: Date
    public var imageName: String
}

public struct SimpleEntry: TimelineEntry {
    public let date: Date
    
    public let currentLesson: WidgetLesson
    public let lessonTime: Date
    public let nextLessons: [WidgetLesson]
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
                    .cornerRadius(10)
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
                                .cornerRadius(10)
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
                    Text("Later:")
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
                                .cornerRadius(10)
                                .frame(width: 100,
                                       height: 20)
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(4)
                                .frame(width: 100,
                                       height: 10)
                        }.padding([.leading, .trailing])
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(10)
                                .frame(width: 100,
                                       height: 20)
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(4)
                                .frame(width: 100,
                                       height: 10)
                        }
                        .padding([.leading, .trailing])
                    }
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .leading)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(GlobalColors.greyThree)).cornerRadius(10, antialiased: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
        default:
            fatalError()
        }
    }
}

struct WidgetComponents {
    struct MediumContent: View {
        var currentLesson: String
        var lessonTime: Date
        
        @ViewBuilder
        var body: some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(currentLesson)
                        .font(
                            .system(
                                size: 20,
                                weight: .bold,
                                design: .default
                            )
                        )
                    Text("Starts at \(Lesson.convert(time: lessonTime.timeIntervalSince(Lesson.getTodayDate())))")
                        .font(
                            .system(
                                size: 12,
                                weight: .regular,
                                design: .default
                            )
                        )
                }.padding([.leading, .trailing])
            }
        }
    }
    
    struct ImageView: View {
        var imageName: String
        var isMedium: Bool
        
        @ViewBuilder
        var body: some View {
            ZStack {
                if !isMedium {
                    Circle()
                        .fill(Color.blue)
                        .frame(
                            width: 40,
                            height: 40
                        )
                    Image(systemName: imageName)
                        .foregroundColor(.white)
                        .frame(
                            width: 20,
                            height: 20
                        )
                        .font(
                            .system(
                                size: 20,
                                weight: .medium,
                                design: .default
                            )
                        )
                } else {
                    Circle()
                        .fill(Color.blue)
                        .frame(
                            width: 30,
                            height: 30
                        )
                    Image(systemName: imageName)
                        .foregroundColor(.white)
                        .frame(
                            width: 8,
                            height: 8
                        )
                        .font(
                            .system(
                                size: 15,
                                weight: .medium,
                                design: .default
                            )
                        )
                }
                
            }
        }
    }
}

struct Widget_TimetableEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ViewBuilder
    var body: some View {
        
        switch family {
        case .systemSmall:
            VStack(alignment: .leading, spacing: 8) {
                WidgetComponents.ImageView(imageName: entry.currentLesson.imageName, isMedium: false)
                Text(entry.currentLesson.name)
                    .font(
                        .system(
                            size: 24,
                            weight: .bold,
                            design: .default
                        )
                    )
                Text("Ends at \(Lesson.convert(time: entry.lessonTime.timeIntervalSince(Lesson.getTodayDate())))")
                    .font(
                        .system(
                            size: 16,
                            weight: .regular,
                            design: .default
                        )
                    )
                
                if let nextLesson = entry.nextLessons.first {
                    Text("Next: \(nextLesson.name)").font(
                        .system(
                            size: 16,
                            weight: .bold,
                            design: .default
                        )
                    )
                } else {
                    Text("That's it for today! 🏠")
                        .font(
                            .system(
                                size: 16,
                                weight: .bold,
                                design: .default
                            )
                        )
                }
                
            }
            .padding(.all, 8)
            .frame(alignment: .leading)
            
        case .systemMedium:
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    HStack(spacing: 8) {
                        WidgetComponents.ImageView(imageName: entry.currentLesson.imageName, isMedium: true)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.currentLesson.name)
                                .font(
                                    .system(
                                        size: 20,
                                        weight: .bold,
                                        design: .default
                                    )
                                )
                            Text("Ends at \(Lesson.convert(time: entry.lessonTime.timeIntervalSince(Lesson.getTodayDate())))")
                                .font(
                                    .system(
                                        size: 12,
                                        weight: .regular,
                                        design: .default
                                    )
                                )
                        }
                    }
                }.padding([.leading, .trailing, .top])
                
                VStack(alignment: .leading) {
                    Text("Later:")
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
                    
                    HStack {
                        if let nextLesson = entry.nextLessons.first {
                            WidgetComponents.MediumContent(currentLesson: nextLesson.name, lessonTime: nextLesson.date)
                            
                            if let lastLesson = entry.nextLessons.last {
                                WidgetComponents.MediumContent(currentLesson: lastLesson.name, lessonTime: lastLesson.date)
                            }
                        } else {
                            Text("No lessons later.")
                                .font(
                                    Font
                                        .system(
                                            size: 16,
                                            weight: .bold,
                                            design: .default
                                        )
                                )
                        }
                    }
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.bottom)
                }
                .background(Color(GlobalColors.greyThree))
                .cornerRadius(10, antialiased: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
        default: fatalError()
        }
    }
}

@main
struct Widget_Timetable: Widget {
    
    // Bundle ID
    private let kind: String = "sg.edu.sst.panziyue.Announcer.Widget-TImetable"
    
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
