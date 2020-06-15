//
//  TTTableViewCell.swift
//  Announcer
//
//  Created by JiaChen(: on 14/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit

class TTTableViewCell: UITableViewCell {

    var selectedDate: Date!
    var lesson: Lesson! {
        didSet {
            let subject = Assets.getSubject(lesson.identifier, font: .systemFont(ofSize: 30, weight: .bold))
            subjectImageView.image = subject.0
            
            // Setting the colors
            if Calendar.current.isDateInToday(selectedDate) {
                let todayTimeInterval = Date().timeIntervalSince(Lesson.todayDate)
                
                if todayTimeInterval > lesson.startTime {
                    topTimelineView.backgroundColor = GlobalColors.blueTint
                    timelineIndicator.tintColor = GlobalColors.blueTint
                    
                    if todayTimeInterval < lesson.endTime {
                    } else {
                        bottomTimelineIndicator.backgroundColor = GlobalColors.blueTint
                    }
                } else {
                    topTimelineView.backgroundColor = GlobalColors.greyThree
                    timelineIndicator.tintColor = GlobalColors.greyThree
                    bottomTimelineIndicator.backgroundColor = GlobalColors.greyThree
                }
            }
            
            if let teacher = lesson.teacher {
                let defaultAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                                         NSAttributedString.Key.foregroundColor: UIColor.label]
                let teacherAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
                
                let attr = NSMutableAttributedString(string: "\(subject.1) • \(teacher)", attributes: defaultAttributes)
                
                attr.addAttributes(teacherAttributes, range: NSRange(location: subject.1.count, length: teacher.count + 3))
                
                subjectTeacherLabel.attributedText = attr
            } else {
                subjectTeacherLabel.text = subject.1
            }
            
            timingLabel.text = "From \(Lesson.convert(time: lesson.startTime)) to \(Lesson.convert(time: lesson.endTime))"
        }
    }
    
    @IBOutlet weak var topTimelineView: UIView!
    @IBOutlet weak var bottomTimelineIndicator: UIView!
    
    @IBOutlet weak var timelineIndicator: UIImageView!
    
    @IBOutlet weak var subjectImageView: UIImageView!
    @IBOutlet weak var subjectTeacherLabel: UILabel!
    
    @IBOutlet weak var timingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
