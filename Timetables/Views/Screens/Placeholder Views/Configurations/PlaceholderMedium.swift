//
//  PlaceholderMedium.swift
//  Timetables
//
//  Created by JiaChen(: on 6/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

extension PlaceholderItem {
    struct Medium: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                VStack {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(
                                    width: 30,
                                    height: 30
                                )
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(6)
                                .frame(width: 100,
                                       height: 20)
                            Rectangle()
                                .fill(Color.secondary)
                                .cornerRadius(4)
                                .frame(width: 100,
                                       height: 10)
                        }
                    }
                }.padding([.leading, .trailing, .top])
                
                VStack(alignment: .leading) {
                    Text("Next:")
                        .font(
                            Font
                                .system(
                                    size: 16,
                                    weight: .bold,
                                    design: .default
                                )
                        )
                        .foregroundColor(
                            .blue
                        )
                        .padding([.leading, .trailing, .top])
                    HStack(alignment: .top) {
                        Components.MediumPlaceholder()
                        
                        Rectangle()
                            .fill(Color.secondary)
                            .frame(
                                width: 1
                            )
                        
                        Components.MediumPlaceholder()
                    }
                    .frame(
                        maxWidth:
                            .infinity,
                        maxHeight:
                            .infinity,
                        alignment:
                            .leading)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Grey 3"))
                .cornerRadius(10, antialiased: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}
