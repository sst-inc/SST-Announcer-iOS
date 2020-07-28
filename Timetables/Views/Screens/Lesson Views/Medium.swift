//
//  Medium.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

extension Screens {
    struct Medium: View {
        var currentLesson: WidgetLesson
        var firstNextLesson: WidgetLesson?
        var secondNextLesson: WidgetLesson?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    HStack(spacing: 8) {
                        Components.ImageView(imageName: currentLesson.imageName, isMedium: true)
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
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding([.leading, .trailing, .top])
                
                VStack(alignment: .leading) {
                    HStack {
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        if let nextLesson = firstNextLesson {
                            Components.MediumContent(currentLesson: nextLesson.name, lessonTime: nextLesson.date)
                            
                            if let lastLesson = secondNextLesson {
                                Rectangle()
                                    .fill(Color.secondary)
                                    .frame(
                                        width: 1
                                    )
                                
                                Components.MediumContent(currentLesson: lastLesson.name, lessonTime: lastLesson.date)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}
