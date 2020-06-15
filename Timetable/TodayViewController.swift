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
    
    var interface: InterfaceStyle!
    
    // Interface elements for ongoing
    var nowLabel: UILabel?
    var laterLabel: UILabel?
    var ongoingSubject: SubjectView?
    var laterSubjects: [SubjectView]?
    
    enum InterfaceStyle {
        case notSetUp
        case lessonOver
        case ongoing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        interface = .ongoing
        
        switch interface {
        case .notSetUp:
            extensionContext?.widgetLargestAvailableDisplayMode = .compact
            createNotSetUpUI()
        case .ongoing:
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            
            createUI()
        case .lessonOver:
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        case .none: break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if interface == .ongoing {
            let oldConstraints = self.view.constraints
            
            if activeDisplayMode == .compact {
                let newConstraints = getOngoingLessonLayout(for: .compact, withViews: view, ongoingSubject!, nowLabel!, laterSubjects!, laterLabel!)
                
                UIView.animate(withDuration: 0.5) {
                    self.view.removeConstraints(oldConstraints)
                    self.view.addConstraints(newConstraints)
                }
                
            } else {
                let newConstraints = getOngoingLessonLayout(for: .expanded, withViews: view, ongoingSubject!, nowLabel!, laterSubjects!, laterLabel!)
                
                UIView.animate(withDuration: 0.5) {
                    self.view.removeConstraints(oldConstraints)
                    self.view.addConstraints(newConstraints)
                }
            }
        }
    }
}
