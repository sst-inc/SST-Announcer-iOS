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
    
    enum InterfaceStyle {
        case notSetUp
        case lessonOver
        case ongoing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        interface = .notSetUp
        
        switch interface {
        case .notSetUp:
            extensionContext?.widgetLargestAvailableDisplayMode = .compact
            createNotSetUpUI()
        case .ongoing:
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        case .lessonOver:
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        case .none: break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            print("compact")
        } else {
            print("expanded")
        }
    }
    
    func createNotSetUpUI() {
        let view = UIView(frame: self.view.frame)
        
        let titleLabel = UILabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold),
                              NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let subtitleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular),
                                 NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let attributedStr = NSMutableAttributedString(string: "Tap to set-up Announcer Timetable\n\nUse Announcer Timetable to find out what lesson is happening next from this widget.", attributes: titleAttribute)
        
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
    
    func createUI() {
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
