//
//  TodayWeekend.swift
//  Timetable
//
//  Created by JiaChen(: on 20/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension TodayViewController {
    func setUpWeekend() {
        let ongoingSubject = SubjectView("weekend", subtitle: "Do no harm to yourself,\nDo no harm to others,\nDo no harm to the school.", vc: self)
        
        ongoingSubject.translatesAutoresizingMaskIntoConstraints = false
        
        let ongoingSubjectConstraints = [NSLayoutConstraint(item: ongoingSubject,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .top,
                                                            multiplier: 1,
                                                            constant: 0),
                                         NSLayoutConstraint(item: ongoingSubject,
                                                            attribute: .leading,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .leading,
                                                            multiplier: 1,
                                                            constant: 8),
                                         NSLayoutConstraint(item: ongoingSubject,
                                                            attribute: .trailing,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .trailing,
                                                            multiplier: 1,
                                                            constant: 8)]
        
        view.addSubview(ongoingSubject)
        
        view.addConstraints(ongoingSubjectConstraints)
    }
}
