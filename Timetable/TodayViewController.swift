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
    
    var nowTitleLabel = UILabel()
    
    override func loadView() {
        let subjectView = createSubject("test subject", image: Assets.subjectIcons["el"], teacher: <#T##String?#>, subtitle: <#T##String?#>)
        view.addSubview(<#T##view: UIView##UIView#>)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func createSubject(_ subject: String, image iconImage: UIImage, teacher: String? = nil, subtitle: String? = nil) -> UIView {
        
        let subjectView = UIView()
        
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        
        let iconImageView = UIImageView()
        
        //
        
        subjectView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageViewConstraints = [NSLayoutConstraint(item: iconImageView,
                                                           attribute: .leading,
                                                           relatedBy: .equal,
                                                           toItem: subjectView,
                                                           attribute: .leading,
                                                           multiplier: 1,
                                                           constant: 8),
                                        NSLayoutConstraint(item: iconImageView,
                                                           attribute: .top,
                                                           relatedBy: .equal,
                                                           toItem: subjectView,
                                                           attribute: .top,
                                                           multiplier: 1,
                                                           constant: 8),
                                        NSLayoutConstraint(item: iconImageView,
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .width,
                                                           multiplier: 1,
                                                           constant: 0)]
        
        let titleLabelViewConstraints = [NSLayoutConstraint(item: titleLabel,
                                                            attribute: .leading,
                                                            relatedBy: .equal,
                                                            toItem: iconImageView,
                                                            attribute: .trailing,
                                                            multiplier: 1,
                                                            constant: 16),
                                         NSLayoutConstraint(item: titleLabel,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: iconImageView,
                                                            attribute: .height,
                                                            multiplier: 1,
                                                            constant: 16),
                                         NSLayoutConstraint(item: titleLabel,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: subjectView,
                                                            attribute: .top,
                                                            multiplier: 1,
                                                            constant: 8),
                                         NSLayoutConstraint(item: titleLabel,
                                                            attribute: .trailing,
                                                            relatedBy: .equal,
                                                            toItem: subjectView,
                                                            attribute: .trailing,
                                                            multiplier: 1,
                                                            constant: 8)]
        
        let subtitleLabelViewConstraints = [NSLayoutConstraint(item: subtitleLabel,
                                                               attribute: .leading,
                                                               relatedBy: .equal,
                                                               toItem: subjectView,
                                                               attribute: .leading,
                                                               multiplier: 1,
                                                               constant: 8),
                                            NSLayoutConstraint(item: subtitleLabel,
                                                               attribute: .top,
                                                               relatedBy: .equal,
                                                               toItem: iconImageView,
                                                               attribute: .bottom,
                                                               multiplier: 1,
                                                               constant: 8),
                                            NSLayoutConstraint(item: subtitleLabel,
                                                               attribute: .bottom,
                                                               relatedBy: .equal,
                                                               toItem: subjectView,
                                                               attribute: .bottom,
                                                               multiplier: 1,
                                                               constant: 8),
                                            NSLayoutConstraint(item: subtitleLabel,
                                                               attribute: .trailing,
                                                               relatedBy: .equal,
                                                               toItem: subjectView,
                                                               attribute: .trailing,
                                                               multiplier: 1,
                                                               constant: 8)]
        
        subjectView.addSubview(iconImageView)
        subjectView.addSubview(titleLabel)
        subjectView.addSubview(subtitleLabel)
        
        subjectView.addConstraints(iconImageViewConstraints)
        subjectView.addConstraints(titleLabelViewConstraints)
        subjectView.addConstraints(subtitleLabelViewConstraints)
        
        return subjectView
    }
}
