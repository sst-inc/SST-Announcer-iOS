//
//  ScrollSelection.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

struct ScrollSelection {
    static func setNormalState(for item: UIView? = nil, barButton: UIBarButtonItem? = nil) {
        if let item = item {
            if let button = item as? UIButton {
                        button.layer.borderWidth = 0
                        button.layer.borderColor = GlobalColors.borderColor
                    } else if let searchBar = item as? UISearchBar {
                        searchBar.alpha = 1
                    }
        } else {
            barButton?.tintColor = GlobalColors.greyOne
        }
    }
    
    static func setSelectedState(for item: UIView? = nil,
                                 barButton: UIBarButtonItem? = nil,
                                 withOffset offset: CGFloat,
                                 andConstant constant: CGFloat) {
        let multiplier = (offset * -1 - constant) / 100

        if let item = item {
            if let button = item as? UIButton {

                button.layer.borderWidth = 25 * multiplier
                button.layer.borderColor = GlobalColors.borderColor
            } else if let searchBar = item as? UISearchBar {
                searchBar.alpha = 1 - (multiplier * 2)
            }
        } else {
            barButton?.tintColor = GlobalColors.greyOne.withAlphaComponent(1 - (multiplier * 2))
        }
    }
}
