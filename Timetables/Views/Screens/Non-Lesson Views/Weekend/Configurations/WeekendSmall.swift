//
//  Small.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

struct WeekendViews {
    struct Small: View {
        
        @ViewBuilder
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Components.ImageView(imageName: "calendar", isMedium: false)
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
        }
    }
}
