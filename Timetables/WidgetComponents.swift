//
//  WidgetComponents.swift
//  Timetables
//
//  Created by JiaChen(: on 5/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

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
            }.frame(maxWidth: CGFloat.infinity, alignment: .leading)
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
                        .fill(RadialGradient(gradient: Gradient(colors: [Color.blue, Color.white]),
                                             center: .center,
                                             startRadius: 0, endRadius: 70))
                        .frame(
                            width: 40,
                            height: 40
                        )
                    Image(systemName: imageName)
//                        .imageScale(.large)
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
                        .fill(RadialGradient(gradient: Gradient(colors: [Color.blue, Color.white]),
                                             center: .center,
                                             startRadius: 0, endRadius: 55))
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
    
    struct NoLessonsView: View {
        var family: WidgetFamily
        
        @ViewBuilder
        var body: some View {
            switch family {
            case .systemSmall:
                VStack(alignment: .leading, spacing: 8) {
                    ImageView(imageName: "house", isMedium: false)
                    Text("No Lessons")
                        .font(
                            .system(
                                size: 24,
                                weight: .bold,
                                design: .default
                            )
                        )
                    Text("There are no ongoing lessons!")
                        .font(
                            .system(
                                size: 16,
                                weight: .regular,
                                design: .default
                            )
                        )
                }
                .padding(.all, 8)
                .frame(alignment: .leading)
                
            case .systemMedium:
                VStack(alignment: .leading, spacing: 8) {
                    VStack {
                        HStack(spacing: 8) {
                            ImageView(imageName: "house", isMedium: false)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("No ongoing lessons")
                                    .font(
                                        .system(
                                            size: 20,
                                            weight: .bold,
                                            design: .default
                                        )
                                    )
                                Text("There are no lessons happening now.")
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
                }
                    
            default: I.wantToDie
            }
        }
    }
    
    struct WeekendView: View {
        var family: WidgetFamily
        
        @ViewBuilder
        var body: some View {
            if family == .systemSmall {
                VStack(alignment: .leading, spacing: 8) {
                    ImageView(imageName: "calendar", isMedium: false)
                    Text(Date().day())
                        .font(
                            .system(
                                size: 24,
                                weight: .bold,
                                design: .default
                            )
                        )
                    Text("No lessons today.")
                        .font(
                            .system(
                                size: 16,
                                weight: .regular,
                                design: .default
                            )
                        )
                }
                .padding()
                .frame(alignment: .leading)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    VStack {
                        HStack(spacing: 8) {
                            ImageView(imageName: "calendar", isMedium: false)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("It's \(Date().day())!")
                                    .font(
                                        .system(
                                            size: 20,
                                            weight: .bold,
                                            design: .default
                                        )
                                    )
                                Text("There are no lessons on weekends.")
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
                }
            }
        }
    }
    
    struct Small: View {
        var currentLesson: WidgetLesson
        var firstNextLesson: WidgetLesson?
        
        @ViewBuilder
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                ImageView(imageName: currentLesson.imageName, isMedium: false)
                Text(currentLesson.name)
                    .font(
                        .system(
                            size: 24,
                            weight: .bold,
                            design: .default
                        )
                    )
                Text("Ends at \(Lesson.convert(time: currentLesson.date.timeIntervalSince(Lesson.getTodayDate())))")
                    .font(
                        .system(
                            size: 16,
                            weight: .regular,
                            design: .default
                        )
                    )
                
                if let nextLesson = firstNextLesson {
                    Text("Next: \(nextLesson.name)").font(
                        .system(
                            size: 16,
                            weight: .bold,
                            design: .default
                        )
                    )
                } else {
                    Text("🏠 That's it!")
                        .font(
                            .system(
                                size: 16,
                                weight: .bold,
                                design: .default
                            )
                        )
                }
                
            }
            .padding(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
    
    struct Medium: View {
        var currentLesson: WidgetLesson
        var firstNextLesson: WidgetLesson?
        var secondNextLesson: WidgetLesson?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    HStack(spacing: 8) {
                        ImageView(imageName: currentLesson.imageName, isMedium: true)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentLesson.name)
                                .font(
                                    .system(
                                        size: 20,
                                        weight: .bold,
                                        design: .default
                                    )
                                )
                            Text("Ends in \(currentLesson.date, style: .relative)")
                                .font(
                                    .system(
                                        size: 12,
                                        weight: .regular,
                                        design: .default
                                    )
                                )
                        }
                    }
                }
                .padding([.leading, .trailing, .top])
                
                VStack(alignment: .leading) {
                    HStack {
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
//                        if firstNextLesson != nil {
//                            Text("In \(currentLesson.date, style: .relative)")
//                                .font(
//                                    Font
//                                        .system(
//                                            size: 16,
//                                            weight: .medium,
//                                            design: .default
//                                        )
//                                )
//                                .padding([.leading,
//                                          .trailing,
//                                          .top])
//                                .frame(maxWidth: .infinity, alignment: .trailing)
//                        }
                    }
                    
                    HStack {
                        if let nextLesson = firstNextLesson {
                            MediumContent(currentLesson: nextLesson.name, lessonTime: nextLesson.date)
                            
                            if let lastLesson = secondNextLesson {
                                Rectangle()
                                    .fill(Color.secondary)
                                    .frame(
                                        width: 1
                                    )
                                
                                MediumContent(currentLesson: lastLesson.name, lessonTime: lastLesson.date)
                            }
                        } else {
                            Text("🏠 Well, that's it!")
                                .font(
                                    Font
                                        .system(
                                            size: 16,
                                            weight: .bold,
                                            design: .default
                                        )
                                )
                                .padding(.leading)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.bottom)
                }
                .background(Color("Grey 3"))
                .cornerRadius(10, antialiased: true)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}


struct WidgetComponents_Previews: PreviewProvider {
    static var previews: some View {
        WidgetComponents.WeekendView(family: .systemMedium)
    }
}
