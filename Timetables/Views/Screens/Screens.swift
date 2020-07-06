//
//  WidgetView.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

struct Screens {
    struct Default: View {
        var family: WidgetFamily
        
        var currentLesson: WidgetLesson
        var firstNextLesson: WidgetLesson?
        var secondNextLesson: WidgetLesson?
        
        @ViewBuilder
        var body: some View {
            switch family {
            case .systemSmall:
                Screens.Small(currentLesson: currentLesson,
                              firstNextLesson: firstNextLesson)
            case .systemMedium:
                Screens.Medium(currentLesson: currentLesson,
                               firstNextLesson: firstNextLesson,
                               secondNextLesson: secondNextLesson)
            default:
                I.wantToDie
            }
        }
    }
}
