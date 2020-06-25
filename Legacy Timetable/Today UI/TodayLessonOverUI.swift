//
//  TodayLessonOverUI.swift
//  Timetable
//
//  Created by JiaChen(: on 20/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension TodayViewController {
    func lessonOverUI() {
        let view = UIView(frame: self.view.frame)
        
        let subjectView = SubjectView("|over|", subtitle: "Remember to do your homework!", vc: self)
        
        let lessonEndedLabel = createHeaderLabels(withText: "Lesson has ended for the day.")
        
        let lessonEndedLabelConstraints = [NSLayoutConstraint(item: lessonEndedLabel,
                                                              attribute: .top,
                                                              relatedBy: .equal,
                                                              toItem: view,
                                                              attribute: .top,
                                                              multiplier: 1,
                                                              constant: 8),
                                           NSLayoutConstraint(item: lessonEndedLabel,
                                                              attribute: .leading,
                                                              relatedBy: .equal,
                                                              toItem: view,
                                                              attribute: .leading,
                                                              multiplier: 1,
                                                              constant: 16)]
        
        let subjectViewConstraints = [NSLayoutConstraint(item: subjectView,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: lessonEndedLabel,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: 0),
                                      NSLayoutConstraint(item: subjectView,
                                                         attribute: .leading,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .leading,
                                                         multiplier: 1,
                                                         constant: 8),
                                      NSLayoutConstraint(item: subjectView,
                                                         attribute: .trailing,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .trailing,
                                                         multiplier: 1,
                                                         constant: 8)]
        
        let constraints = lessonEndedLabelConstraints + subjectViewConstraints
        
        view.addSubview(subjectView)
        
        view.addConstraints(constraints)
        
        self.view = view
    }
}
