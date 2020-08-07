//
//  Components.swift
//  Timetables
//
//  Created by JiaChen(: on 5/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

struct Components {
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
                    Text("STARTS_AT \(Lesson.convert(time: lessonTime.timeIntervalSince(Lesson.getTodayDate())))")
                        .font(
                            .system(
                                size: 12,
                                weight: .regular,
                                design: .default
                            )
                        )
                }.padding(
                    [
                        .leading,
                        .trailing
                    ]
                )
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
    }
}
