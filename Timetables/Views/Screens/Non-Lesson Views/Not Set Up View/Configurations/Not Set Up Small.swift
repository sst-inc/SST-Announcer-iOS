//
//  NotSetUpSmall.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

struct NotSetUpItem {
    struct Small: View {
        var body: some View {
            VStack(alignment: .leading) {
                Components.ImageView(imageName: "gearshape", isMedium: false)
                Text(Localized.SetUp.Title.s)
                    .font(
                        .system(
                            size: 20,
                            weight: .bold,
                            design: .default
                        )
                    )
                Text(Localized.SetUp.description)
                    .font(
                        .system(
                            size: 12,
                            weight: .regular,
                            design: .default
                        )
                    )
            }.padding([.all])
        }
    }
}

struct NotSetUpSmallPreview: PreviewProvider {
    static var previews: some View {
        NotSetUpItem.Small()
    }
}
