//
//  ImageView.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI

extension Components {
    struct ImageView: View {
        var imageName: String
        var isMedium: Bool
        
        @ViewBuilder
        var body: some View {
            if !isMedium {
                ImageViewItem.Small(imageName: imageName)
            } else {
                ImageViewItem.Medium(imageName: imageName)
            }
        }
    }
}
