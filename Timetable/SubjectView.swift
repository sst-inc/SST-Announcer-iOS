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
    
    private let titleTextSize: CGFloat = 20
    
    private let iconSize: CGFloat = 30
    
    private let subtitleTextSize: CGFloat = 16

    
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
    
    
    
    init(_ iconImageId: String, teacher: String? = nil, subtitle: String? = nil) {
        super.init(frame: .zero)
        
        let subjectInfo = Assets.getSubject(iconImageId, font: .systemFont(ofSize: iconSize, weight: .bold))
        
        commonInit(subjectInfo.1, image: subjectInfo.0, teacher: teacher, subtitle: subtitle)
        
        self.subtitle = subject
        self.iconImage = subjectInfo.0
        self.teacher = teacher
        self.subtitle = subtitle
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit("", image: .init())
    }

    func commonInit(_ subject: String, image iconImage: UIImage, teacher: String? = nil, subtitle: String? = nil) {
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        let iconImageView = UIImageView()
        
        let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleTextSize, weight: .heavy)]
        let teacherAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleTextSize, weight: .regular)]
        
        if let teacher = teacher {
            let attributedStr = NSMutableAttributedString(string: subject + " • " + teacher, attributes: normalAttributes)
            
            attributedStr.addAttributes(teacherAttributes, range: NSRange(location: subject.count, length: teacher.count + 3))
            
            titleLabel.attributedText = attributedStr
        } else {
            titleLabel.text = (teacher == nil) ? subject : subject + " • " + teacher!
        }
        
        // Setting up subtitleLabel
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: subtitleTextSize, weight: .regular)
        
        // Setting up iconImageView
        iconImageView.image = iconImage
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemBlue
        
        // Setting up layout constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
                                                            constant: 16),
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
        
        // Adding constraints
        addConstraints(subtitleLabelViewConstraints + titleLabelViewConstraints + iconImageViewConstraints)
        
        // Updating view's variables
        self.titleLabel = titleLabel
        self.subtitleLabel = subtitleLabel
        self.iconImageView = iconImageView
    }

    func updateTitleLabel() {
        let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleTextSize, weight: .heavy)]
        let teacherAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleTextSize, weight: .regular)]
        
        if let teacher = teacher {
            let attributedStr = NSMutableAttributedString(string: subject ?? "" + " • " + teacher, attributes: normalAttributes)
            
            attributedStr.addAttributes(teacherAttributes, range: NSRange(location: (subject ?? "").count, length: teacher.count + 3))
            
            titleLabel.attributedText = attributedStr
        } else {
            let attributedStr = NSMutableAttributedString(string: subject ?? "")
            
            titleLabel.attributedText = attributedStr
        }
        
    }
}
