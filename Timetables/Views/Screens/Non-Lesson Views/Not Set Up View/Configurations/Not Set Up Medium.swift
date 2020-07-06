//
//  NotSetUpMedium.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

extension NotSetUpItem {
    struct Medium: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    HStack(spacing: 8) {
                        Components.ImageView(imageName: "gearshape", isMedium: false)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Set-up Timetables")
                                .font(
                                    .system(
                                        size: 20,
                                        weight: .bold,
                                        design: .default
                                    )
                                )
                            Text("Announcer Timetables is not set-up.\nTap to set it up.")
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
