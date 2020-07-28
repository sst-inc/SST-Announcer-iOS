//
//  No Lesson Small.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct NoLesson {
    struct Small: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Components.ImageView(imageName: "house", isMedium: false)
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
        }
    }
}
