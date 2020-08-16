//
//  WeekendMedium.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

extension WeekendViews {
    struct Medium: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    HStack(spacing: 8) {
                        Components.ImageView(imageName: "calendar", isMedium: false)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TODAY_IS \(Date().day())")
                                .font(
                                    .system(
                                        size: 20,
                                        weight: .bold,
                                        design: .default
                                    )
                                )
                            Text(Localized.No.Lessons.m)
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
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
        }
    }
}
