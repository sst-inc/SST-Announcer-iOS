//
//  No Lessons.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

extension Screens {
    struct NoLessonsView: View {
        var family: WidgetFamily
        
        @ViewBuilder
        var body: some View {
            switch family {
            case .systemSmall:
                NoLesson.Small()
                
            case .systemMedium:
                NoLesson.Medium()
                
            default: I.wantToDie
            }
        }
    }
    
}
