//
//  TodayViewController.swift
//  Timetable
//
//  Created by JiaChen(: on 11/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var lessons: [Lesson] = []
    
    var interface: InterfaceStyle! {
        didSet {
            // Resetting interface
            view.subviews.forEach { $0.removeFromSuperview() }
            
            switch interface {
            case .notSetUp:
                extensionContext?.widgetLargestAvailableDisplayMode = .compact
                createNotSetUpUI()
            case .ongoing:
                extensionContext?.widgetLargestAvailableDisplayMode = .expanded
                createUI()
            case .lessonOver:
                extensionContext?.widgetLargestAvailableDisplayMode = .compact
                lessonOverUI()
            case .weekend:
                extensionContext?.widgetLargestAvailableDisplayMode = .compact
                setUpWeekend()
            case .none: break
            }
        }
    }
    
    // Interface elements for ongoing
    var nowLabel: UILabel?
    var laterLabel: UILabel?
    var ongoingSubject: SubjectView?
    var laterSubjects: [SubjectView]?
    
    var currentLesson = 0
    
    var timetable: Timetable?
    
    enum InterfaceStyle {
        case notSetUp
        case lessonOver
        case ongoing
        case weekend
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            if let tt = Timetable.get() {
                self.timetable = tt
                
                self.daysChanged()
                
                // Handling when the day changes
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(self.daysChanged),
                                                       name: .NSCalendarDayChanged,
                                                       object: nil)
                
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(self.daysChanged),
                                                       name: UIApplication.significantTimeChangeNotification,
                                                       object: nil)
                
                self.interface = self.lessons == [] ? .weekend : .ongoing
                
                self.updateLesson()
            } else {
                self.interface = .notSetUp
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        var currentSize: CGSize = self.preferredContentSize
//        currentSize.height = 200.0
//
//        self.preferredContentSize = currentSize
        
    }
    
    override func loadView() {
        super.loadView()
        
//        self.interface = .notSetUp
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    override func attemptRecovery(fromError error: Error, optionIndex recoveryOptionIndex: Int) -> Bool {
        print(error.localizedDescription)
        
        return true  
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if interface == .ongoing {
            let oldConstraints = self.view.constraints
            
            if activeDisplayMode == .compact {
                let newConstraints = getOngoingLessonLayout(for: .compact, withViews: view, ongoingSubject!, nowLabel!, laterSubjects!, laterLabel!)
                
//                preferredContentSize.height = 200
                
                UIView.animate(withDuration: 0.5) {
                    self.view.removeConstraints(oldConstraints)
                    self.view.addConstraints(newConstraints)
                }
                
            } else {
                let newConstraints = getOngoingLessonLayout(for: .expanded, withViews: view, ongoingSubject!, nowLabel!, laterSubjects!, laterLabel!)
                
//                preferredContentSize.height = 280
                
                UIView.animate(withDuration: 0.5) {
                    self.view.removeConstraints(oldConstraints)
                    self.view.addConstraints(newConstraints)
                }
            }
        }
    }
}
