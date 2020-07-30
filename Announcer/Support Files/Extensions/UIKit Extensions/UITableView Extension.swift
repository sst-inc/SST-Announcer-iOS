//
//  UITableView.swift
//  Announcer
//
//  Created by JiaChen(: on 15/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func setEmptyState(_ message: NSAttributedString) {
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: self.bounds.size.width,
                                                 height: self.bounds.size.height))
        
        messageLabel.textColor = .label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.attributedText = message
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
}
