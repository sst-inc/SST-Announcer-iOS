//
//  TodaySetUpUI.swift
//  Timetable
//
//  Created by JiaChen(: on 12/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import NotificationCenter
import UIKit

extension TodayViewController {
    func createNotSetUpUI() {
        let view = UIView(frame: self.view.frame)
        
        let titleLabel = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold),
                              NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let subtitleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
                                 NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let attributedStr = NSMutableAttributedString(string:
                                                      """
                                                      Tap to set-up Announcer Timetable
                                                      
                                                      Use Announcer Timetable to find out what lesson is happening next from this widget.
                                                      """, attributes: titleAttribute)
        
        attributedStr.addAttributes(subtitleAttribute, range: NSRange(location: 34, length: 84))
        
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedStr
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 16),
                           NSLayoutConstraint(item: titleLabel,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 16),
                           NSLayoutConstraint(item: titleLabel,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0),
                           NSLayoutConstraint(item: titleLabel,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0)]
        
        view.addSubview(titleLabel)
        
        view.addConstraints(constraints)
        
        self.view = view
    }
}
