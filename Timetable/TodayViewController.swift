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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        createUI()
        
    }
    
    
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            print("compact")
        } else {
            print("expanded")
        }
    }
    
    func createUI() {
        super.loadView()

        let view = UIView(frame: self.view.frame)

        let subjectView = SubjectView("comp", teacher: "Aurelius Yeo", subtitle: "This is a test")

        subjectView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(subjectView)

        view.addConstraints([NSLayoutConstraint(item: subjectView,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .top,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: subjectView,
                                                attribute: .leading,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .leading,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: subjectView,
                                                attribute: .trailing,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .trailing,
                                                multiplier: 1,
                                                constant: 0)])

        self.view = view
    }

}
