//
//  No Lesson Medium.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

extension NoLesson {
    struct Medium: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    HStack(spacing: 8) {
                        Components.ImageView(imageName: "house", isMedium: false)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Localized.No.Ongoing.Lessons.Title.m)
                                .font(
                                    .system(
                                        size: 20,
                                        weight: .bold,
                                        design: .default
                                    )
                                )
                            Text(Localized.No.Ongoing.Lessons.Description.m)
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
            }
        }
    }
}
