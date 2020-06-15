//
//  TodayUISetUp.swift
//  Timetable
//
//  Created by JiaChen(: on 12/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import NotificationCenter
import UIKit

extension TodayViewController {
    func createUI() {
        let view = UIView(frame: self.view.frame)

        let ongoingSubject = SubjectView("break", subtitle: "Ends in 10 min 5 sec")

        let nowLabel = createHeaderLabels(withText: "Now:")
        
        let laterSubjects = [SubjectView("bio", subtitle: "Starts at 10am"),
                             SubjectView("s&w", subtitle: "Starts at 11am")]
        
        let laterLabel = createHeaderLabels(withText: "Later:")
        
        ongoingSubject.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nowLabel)
        view.addSubview(ongoingSubject)
        view.addSubview(laterLabel)
        
        for i in laterSubjects {
            i.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(i)
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(getOngoingLessonLayout(for: extensionContext!.widgetActiveDisplayMode, withViews: view, ongoingSubject, nowLabel, laterSubjects, laterLabel))

        self.nowLabel = nowLabel
        self.ongoingSubject = ongoingSubject
        self.laterSubjects = laterSubjects
        self.laterLabel = laterLabel
        
        self.view = view
    }
    
    func getOngoingLessonLayout(for mode: NCWidgetDisplayMode,
                                withViews view: UIView,
                                _ ongoingSubject: SubjectView,
                                _ nowLabel: UILabel,
                                _ laterSubjects: [SubjectView],
                                _ laterLabel: UILabel) -> [NSLayoutConstraint] {
        
        // Constraints that will not change when mode changes
        let ongoingSubjectConstraints = [NSLayoutConstraint(item: ongoingSubject,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: nowLabel,
                                                            attribute: .bottom,
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
        
        let nowLabelConstraints = [NSLayoutConstraint(item: nowLabel,
                                                      attribute: .top,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .top,
                                                      multiplier: 1,
                                                      constant: 8),
                                   NSLayoutConstraint(item: nowLabel,
                                                      attribute: .leading,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .leading,
                                                      multiplier: 1,
                                                      constant: 16)]
        
        var constraints = ongoingSubjectConstraints + nowLabelConstraints
        
        switch mode {
        case .compact:
            laterSubjects[0].alpha = 0
            laterSubjects[1].alpha = 0
            laterLabel.alpha = 0
            
        case .expanded:
            laterSubjects[0].alpha = 1
            laterSubjects[1].alpha = 1
            laterLabel.alpha = 1
            
            let laterLabelConstraints = [NSLayoutConstraint(item: laterLabel,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: ongoingSubject,
                                                            attribute: .bottom,
                                                            multiplier: 1,
                                                            constant: 32),
                                         NSLayoutConstraint(item: laterLabel,
                                                            attribute: .leading,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .leading,
                                                            multiplier: 1,
                                                            constant: 16),
                                         NSLayoutConstraint(item: laterLabel,
                                                            attribute: .trailing,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .trailing,
                                                            multiplier: 1,
                                                            constant: 16)]
            
            let laterSubjectConstraints = [NSLayoutConstraint(item: laterSubjects[0],
                                                              attribute: .top,
                                                              relatedBy: .equal,
                                                              toItem: laterLabel,
                                                              attribute: .bottom,
                                                              multiplier: 1,
                                                              constant: 8),
                                           NSLayoutConstraint(item: laterSubjects[0],
                                                              attribute: .leading,
                                                              relatedBy: .equal,
                                                              toItem: view,
                                                              attribute: .leading,
                                                              multiplier: 1,
                                                              constant: 8),
                                           NSLayoutConstraint(item: laterSubjects[0],
                                                              attribute: .trailing,
                                                              relatedBy: .equal,
                                                              toItem: view,
                                                              attribute: .trailing,
                                                              multiplier: 1,
                                                              constant: 8),
                                           NSLayoutConstraint(item: laterSubjects[1],
                                                              attribute: .top,
                                                              relatedBy: .equal,
                                                              toItem: laterSubjects[0],
                                                              attribute: .bottom,
                                                              multiplier: 1,
                                                              constant: 8),
                                           NSLayoutConstraint(item: laterSubjects[1],
                                                              attribute: .leading,
                                                              relatedBy: .equal,
                                                              toItem: view,
                                                              attribute: .leading,
                                                              multiplier: 1,
                                                              constant: 8),
                                           NSLayoutConstraint(item: laterSubjects[1],
                                                              attribute: .trailing,
                                                              relatedBy: .equal,
                                                              toItem: view,
                                                              attribute: .trailing,
                                                              multiplier: 1,
                                                              constant: 8),
                                           NSLayoutConstraint(item: laterSubjects[1],
                                                              attribute: .bottom,
                                                              relatedBy: .equal,
                                                              toItem: view,
                                                              attribute: .bottom,
                                                              multiplier: 1,
                                                              constant: -16)]
            
            constraints += laterLabelConstraints
            constraints += laterSubjectConstraints
            
        @unknown default: fatalError()
        }
        
        return constraints
    }

    func createHeaderLabels(withText text: String) -> UILabel {
        let headerLabel = UILabel()
        
        headerLabel.text = text
        
        headerLabel.textColor = .systemBlue
        
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        headerLabel.textAlignment = .left
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return headerLabel
    }

}
