//
//  WidgetViews.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

extension Screens {
    struct Small: View {
        var currentLesson: WidgetLesson
        var firstNextLesson: WidgetLesson?
        
        @ViewBuilder
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Components.ImageView(imageName: currentLesson.imageName, isMedium: false)
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
}
