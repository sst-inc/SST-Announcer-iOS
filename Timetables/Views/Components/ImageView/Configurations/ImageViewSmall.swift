//
//  Image View Small.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct ImageViewItem {
    struct Small: View {
        var imageName: String
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(RadialGradient(gradient: Gradient(colors: [Color.blue, Color.white]),
                                         center: .center,
                                         startRadius: 0, endRadius: 70))
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
            }
        }
    }
}
