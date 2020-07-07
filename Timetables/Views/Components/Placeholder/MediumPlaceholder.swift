//
//  MediumPlaceholder.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI

extension Components {
    struct MediumPlaceholder: View {
        var body: some View {
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                Rectangle()
                    .fill(Color.secondary)
                    .cornerRadius(6)
                    .frame(
                        width: 100,
                        height: 20
                    )
                Rectangle()
                    .fill(Color.secondary)
                    .cornerRadius(4)
                    .frame(
                        width: 100,
                        height: 10
                    )
            }
            .padding(
                [
                    .leading,
                    .trailing
                ]
            )
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
    }
}
