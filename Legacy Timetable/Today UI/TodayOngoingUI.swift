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

        let ongoingSubject = SubjectView("other", subtitle: "Ends at 10am", vc: self)

        let nowLabel = createHeaderLabels(withText: "Now:")
        
        let laterSubjects = [SubjectView("other", subtitle: "Starts at 10am", vc: self),
                             SubjectView("other", subtitle: "Starts at 11am", vc: self)]
        
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

    @objc func daysChanged() {
        switch Calendar.current.component(.weekday, from: Date()) {
        case 2:
            lessons = timetable?.monday ?? []
            
        case 3:
            lessons = timetable?.tuesday ?? []
            
        case 4:
            lessons = timetable?.wednesday ?? []
            
        case 5:
            lessons = timetable?.thursday ?? []
            
        case 6:
            lessons = timetable?.friday ?? []
            
        default:
            // No what, why are u using Announcer Timetable on weekends
            lessons = []
        }
    }
    
    func updateLesson() {
        if let ongoingSubject = ongoingSubject, let laterSubjects = laterSubjects, lessons.count > 0 {
            
            let todaysDate = Lesson.getTodayDate()
            
            // Handling before lessons
            if currentLesson == 0 && Date().distance(to: todaysDate.advanced(by: lessons[0].startTime)) > 0 {
                let lesson = lessons[currentLesson]
                
                ongoingSubject.update(identifier: "|before|", subtitle: "Class has not started yet, it starts at \(Lesson.convert(time: lesson.startTime))")
                
                laterSubjects[0].isHidden = true
                laterSubjects[1].isHidden = true
                
                extensionContext?.widgetLargestAvailableDisplayMode = .compact
                
                let timer = Timer(fire: todaysDate.advanced(by: lesson.startTime), interval: 0, repeats: false) { (_) in
                    self.updateLesson()
                }
                
                RunLoop.main.add(timer, forMode: .default)
                
                return
            } else {
                laterSubjects[0].isHidden = false
                laterSubjects[1].isHidden = false
                
                extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            }
            
            if lessons.count > currentLesson - 1 {
                
                let lesson = lessons[currentLesson]
                
                if let teacher = lesson.teacher {
                    ongoingSubject.update(identifier: lesson.identifier, withTeacher: teacher, endTime: lesson.endTime)
                } else {
                    ongoingSubject.update(identifier: lesson.identifier, endTime: lesson.endTime)
                }
                
                
                let timer = Timer(fire: todaysDate.advanced(by: lesson.endTime), interval: 0, repeats: false) { (_) in
                    self.updateLesson()
                }
                
                RunLoop.main.add(timer, forMode: .default)
                
                if lessons.count > currentLesson {
                    let secondLesson = lessons[currentLesson + 1]
                    
                    laterSubjects[0].update(identifier: secondLesson.identifier, withTeacher: secondLesson.teacher, startTime: secondLesson.startTime)
                    
                    if lessons.count > currentLesson + 1 {
                        let thirdLesson = lessons[currentLesson + 2]
                        
                        laterSubjects[1].update(identifier: thirdLesson.identifier, withTeacher: thirdLesson.teacher, startTime: thirdLesson.startTime)
                    } else {
                        laterSubjects[1].isHidden = true
                    }
                } else {
                    laterSubjects[0].isHidden = true
                    laterSubjects[1].isHidden = true
                }
                
                currentLesson += 1
            } else {
                self.interface = .lessonOver
            }
        }
    }
}
