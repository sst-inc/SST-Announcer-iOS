//
//  PlaceholderSmall.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct PlaceholderItem {
    struct Small: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(
                            width: 40,
                            height: 40
                        )
                }
                Rectangle()
                    .fill(Color.secondary)
                    .cornerRadius(6)
                    .frame(width: 100,
                           height: 20)
                Rectangle()
                    .fill(Color.secondary)
                    .cornerRadius(4)
                    .frame(width: 80,
                           height: 10)
                Rectangle()
                    .fill(Color.secondary)
                    .cornerRadius(4)
                    .frame(width: 60,
                           height: 10)
            }
            .padding(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}
