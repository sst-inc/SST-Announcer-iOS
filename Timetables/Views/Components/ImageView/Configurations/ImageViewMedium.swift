//
//  ImageViewMedium.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI

extension ImageViewItem {
    struct Medium: View {
        var imageName: String
        
        var body: some View {
            ZStack {
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
