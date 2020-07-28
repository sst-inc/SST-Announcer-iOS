//
//  Weekend.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

extension Screens {
    struct WeekendView: View {
        var family: WidgetFamily
        
        @ViewBuilder
        var body: some View {
            if family == .systemSmall {
                WeekendViews.Small()
            } else {
                WeekendViews.Medium()
            }
        }
    }
}

struct Weekend_Previews: PreviewProvider {
    static var previews: some View {
        Screens.WeekendView(family: .systemMedium)
    }
}
