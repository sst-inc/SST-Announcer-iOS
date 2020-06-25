//
//  SubjectView.swift
//  Timetable
//
//  Created by JiaChen(: on 11/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit

class SubjectView: UIView {
    
    private var titleLabel: UILabel!
    
    private var subtitleLabel: UILabel!
    
    private var iconImageView: UIImageView!
    
    private var tapGesture: UITapGestureRecognizer!
    
    private let titleTextSize: CGFloat = 20
    
    private let iconSize: CGFloat = 30
    
    private let subtitleTextSize: CGFloat = 16
    
    private var vc: TodayViewController!
    
    /// Setting the lesson subject
    open var subject: String? {
        didSet {
            updateTitleLabel()
        }
    }
    
    /// Setting the iconImage
    open var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
        }
    }
    
    ///  Setting the teacher
    open var teacher: String? {
        didSet {
            updateTitleLabel()
        }
    }
    open var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    init(_ iconImageId: String, teacher: String? = nil, subtitle: String? = nil, vc: TodayViewController) {
        super.init(frame: .zero)
        
        let subjectInfo = Assets.getSubject(iconImageId, font: .systemFont(ofSize: iconSize, weight: .bold))
        
        commonInit(subjectInfo.1, image: subjectInfo.0, teacher: teacher, subtitle: subtitle, vc: vc)
        
        self.subtitle = subject
        self.iconImage = subjectInfo.0
        self.teacher = teacher
        self.subtitle = subtitle
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit("", image: .init(), vc: TodayViewController())
    }

    func commonInit(_ subject: String, image iconImage: UIImage, teacher: String? = nil, subtitle: String? = nil, vc: TodayViewController) {
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        let iconImageView = UIImageView()
        let tapGesture = UITapGestureRecognizer()
        
        let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleTextSize, weight: .bold)]
        let teacherAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleTextSize, weight: .regular)]
        
        if let teacher = teacher {
            let attributedStr = NSMutableAttributedString(string: subject + " • " + teacher, attributes: normalAttributes)
            
            attributedStr.addAttributes(teacherAttributes, range: NSRange(location: subject.count, length: teacher.count + 3))
            
            titleLabel.attributedText = attributedStr
        } else {
            titleLabel.text = (teacher == nil) ? subject : subject + " • " + teacher!
            titleLabel.font = UIFont.systemFont(ofSize: titleTextSize, weight: .bold)
        }
        
        // Setting up subtitleLabel
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: subtitleTextSize, weight: .regular)
        subtitleLabel.numberOfLines = 0
        
        // Setting up iconImageView
        iconImageView.image = iconImage
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemBlue
        
        // Setting up layout constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setting up TodayViewController
        self.vc = vc
        
        // Setting up tap gesture recognizer
        tapGesture.addTarget(self, action: #selector(handleTap))
        
        let iconImageViewConstraints = [NSLayoutConstraint(item: iconImageView,
                                                           attribute: .leading,
                                                           relatedBy: .equal,
                                                           toItem: self,
                                                           attribute: .leading,
                                                           multiplier: 1,
                                                           constant: 8),
                                        NSLayoutConstraint(item: iconImageView,
                                                           attribute: .top,
                                                           relatedBy: .equal,
                                                           toItem: self,
                                                           attribute: .top,
                                                           multiplier: 1,
                                                           constant: 8),
                                        NSLayoutConstraint(item: iconImageView,
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .notAnAttribute,
                                                           multiplier: 1,
                                                           constant: 25),
                                        NSLayoutConstraint(item: iconImageView,
                                                           attribute: .width,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .notAnAttribute,
                                                           multiplier: 1,
                                                           constant: 25)]
        
        let titleLabelViewConstraints = [NSLayoutConstraint(item: titleLabel,
                                                            attribute: .leading,
                                                            relatedBy: .equal,
                                                            toItem: iconImageView,
                                                            attribute: .trailing,
                                                            multiplier: 1,
                                                            constant: 8),
                                         NSLayoutConstraint(item: titleLabel,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: iconImageView,
                                                            attribute: .height,
                                                            multiplier: 1,
                                                            constant: 0),
                                         NSLayoutConstraint(item: titleLabel,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: self,
                                                            attribute: .top,
                                                            multiplier: 1,
                                                            constant: 8),
                                         NSLayoutConstraint(item: titleLabel,
                                                            attribute: .trailing,
                                                            relatedBy: .equal,
                                                            toItem: self,
                                                            attribute: .trailing,
                                                            multiplier: 1,
                                                            constant: 8)]
        
        let subtitleLabelViewConstraints = [NSLayoutConstraint(item: subtitleLabel,
                                                               attribute: .leading,
                                                               relatedBy: .equal,
                                                               toItem: self,
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
                                                               toItem: self,
                                                               attribute: .bottom,
                                                               multiplier: 1,
                                                               constant: 8),
                                            NSLayoutConstraint(item: subtitleLabel,
                                                               attribute: .trailing,
                                                               relatedBy: .equal,
                                                               toItem: self,
                                                               attribute: .trailing,
                                                               multiplier: 1,
                                                               constant: 8)]
        
        // Add items to this SubjectView
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        addGestureRecognizer(tapGesture)
        
        // Adding constraints
        addConstraints(subtitleLabelViewConstraints + titleLabelViewConstraints + iconImageViewConstraints)
        
        // Updating view's variables
        self.titleLabel = titleLabel
        self.subtitleLabel = subtitleLabel
        self.iconImageView = iconImageView
        self.tapGesture = tapGesture
    }

    func updateTitleLabel() {
        let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleTextSize, weight: .bold)]
        let teacherAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleTextSize, weight: .regular)]
        
        if let teacher = teacher, teacher != "" {
            
            let teacherAndSubject = (subject ?? "") + " • " + teacher
            let attributedStr = NSMutableAttributedString(string: teacherAndSubject, attributes: normalAttributes)
            
            attributedStr.addAttributes(teacherAttributes, range: NSRange(location: (subject ?? "").count, length: teacher.count + 3))
            
            titleLabel.attributedText = attributedStr
        } else {
            let attributedStr = NSMutableAttributedString(string: subject ?? "")
            
            titleLabel.attributedText = attributedStr
        }
    }
    
    func update(identifier: String,
                withTeacher teacher: String? = nil,
                subtitle: String? = nil,
                endTime: TimeInterval? = nil,
                startTime: TimeInterval? = nil) {
        
        let subjectInfo = Assets.getSubject(identifier, font: .systemFont(ofSize: iconSize, weight: .bold))
        
        self.subject = subjectInfo.1
        self.iconImage = subjectInfo.0
        
        self.teacher = teacher
        
        if let subtitle = subtitle {
            // Set subtitle to the subtitle, if there is one
            self.subtitle = subtitle
            
        } else if let endTime = endTime {
            // Otherwise, if there is an endTime, use that
            self.subtitle = "Ends at \(Lesson.convert(time: endTime))"
            
        } else if let startTime = startTime {
            // Otherwise, if there is a start time, use that
            self.subtitle = "Starts at \(Lesson.convert(time: startTime))"
            
        } else {
            // Set it to nil when there is nothing, this prevents weird bugs like content passing over
            self.subtitle = nil
            
        }
    }
    
    @objc func handleTap() {
        let appURL = URL(string: "sstannouncer:from?id=1")!
        
        vc.extensionContext?.open(appURL, completionHandler: nil)
    }
}
