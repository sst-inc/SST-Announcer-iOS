//
//  Not Set Up.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

extension Screens {
    struct NotSetUp: View {
        var family: WidgetFamily
        
        @ViewBuilder
        var body: some View {
            switch family {
            case .systemSmall:
                NotSetUpItem.Small()
                
            case .systemMedium:
                NotSetUpItem.Medium()
                
            default: I.wantToDie
            }
        }
    }
}
