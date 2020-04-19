//
//  SetDateViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 29/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class SetDateViewController: UIViewController {
    
    let notifManager = LocalNotificationManager()
    var post: Post!
    var customDate: TimeInterval = 0
    
    var onDismiss: (() -> Void)?
    
    @IBOutlet weak var backgroundRedView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tomorrowDateLabel: UILabel!
    @IBOutlet weak var twoDaysDateLabel: UILabel!
    @IBOutlet weak var nextWeekDateLabel: UILabel!
    @IBOutlet weak var customDateLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    
    // Calendar
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        cancelButton.layer.cornerRadius = 10
        backgroundRedView.alpha = 0
        
        monthLabel.layer.cornerRadius = 5
        monthLabel.clipsToBounds = true
        
        // Load dates in
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, h:mm a"
        
        tomorrowDateLabel.text = formatter.string(from: date.addingTimeInterval(86400))
        twoDaysDateLabel.text = formatter.string(from: date.addingTimeInterval(86400*2))
        nextWeekDateLabel.text = formatter.string(from: date.addingTimeInterval(86400*7))
        customDateLabel.text = formatter.string(from: date.addingTimeInterval(86400*30))
        
        // Set up gesture recogniser
        let tomorrowGestureRecognizer = UITapGestureRecognizer()
        tomorrowGestureRecognizer.addTarget(self, action: #selector(tappedDate(sender:)))
        containerStackView.arrangedSubviews[0].tag = 0
        containerStackView.arrangedSubviews[0].addGestureRecognizer(tomorrowGestureRecognizer)
        
        let twoDaysGestureRecognizer = UITapGestureRecognizer()
        twoDaysGestureRecognizer.addTarget(self, action: #selector(tappedDate(sender:)))
        containerStackView.arrangedSubviews[1].tag = 1
        containerStackView.arrangedSubviews[1].addGestureRecognizer(twoDaysGestureRecognizer)
        
        let nextWeekGestureRecognizer = UITapGestureRecognizer()
        nextWeekGestureRecognizer.addTarget(self, action: #selector(tappedDate(sender:)))
        containerStackView.arrangedSubviews[2].tag = 2
        containerStackView.arrangedSubviews[2].addGestureRecognizer(nextWeekGestureRecognizer)
        
        let customGestureRecognizer = UITapGestureRecognizer()
        customGestureRecognizer.addTarget(self, action: #selector(tappedDate(sender:)))
        containerStackView.arrangedSubviews[3].tag = 3
        containerStackView.arrangedSubviews[3].addGestureRecognizer(customGestureRecognizer)
        
        loadNewMonth(20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.backgroundRedView.alpha = 0.75
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundRedView.alpha = 0
        }) { (_) in
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        let date = Date().addingTimeInterval(customDate)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy M"
        var year = Int(dateFormatter.string(from: date).split(separator: " ")[0])
        var month = Int(dateFormatter.string(from: date).split(separator: " ")[1])

        if month == 12 {
            month = 1
            year! += 1
        } else {
            month! += 1
        }
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let newDate = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: newDate)!
        
        // Number of days in a month
        let numDays = range.count
        let seconds: TimeInterval = TimeInterval(numDays * 86400)
        
        customDate += seconds
        loadNewMonth(customDate)
    }
    
    @IBAction func lastMonth(_ sender: Any) {
        let date = Date().addingTimeInterval(customDate)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy M"
        var year = Int(dateFormatter.string(from: date).split(separator: " ")[0])
        var month = Int(dateFormatter.string(from: date).split(separator: " ")[1])

        if month == 1 {
            month = 12
            year! -= 1
        } else {
            month! -= 1
        }
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let newDate = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: newDate)!
        
        // Number of days in a month
        let numDays = range.count
        let seconds: TimeInterval = TimeInterval(numDays * 86400)
        
        customDate -= seconds
        loadNewMonth(customDate)
    }
    
    @objc func tappedDate(sender: UITapGestureRecognizer) {
        switch sender.view!.tag {
        case 0:
            // Tomorrow
            notification(86400)
        case 1:
            // 2 Days
            notification(86400*2)
        case 2:
            // Next Week
            notification(86400*7)
        case 3:
            // custom
            notification(customDate)
        default:
            break
        }
        dismiss(animated: true)
        
        // onDismiss?() will set the icons for the next screen
        onDismiss?()
    }
    
    @objc func tappedCalendarDate(sender: UITapGestureRecognizer) {
        let label: UILabel = sender.view! as! UILabel
        
        let date = Date().addingTimeInterval(customDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        let oldDate = TimeInterval(dateFormatter.string(from: date))!
        print(oldDate)
        let newDate = TimeInterval(label.text!)!
        
        customDate = newDate - oldDate * 86400
        
        loadNewMonth(customDate)
    }
    
    func loadNewMonth(_ timeInterval: TimeInterval) {
        let date = Date().addingTimeInterval(timeInterval)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = "\(dateFormatter.string(from: date))"
        
        var calendarItems = calendarStackView.arrangedSubviews
        // calendarItems.first is the M T W T F S S
        // Therefore, im removing it
        calendarItems.removeFirst()
        
        dateFormatter.dateFormat = "yyyy M"
        let year = Int(dateFormatter.string(from: date).split(separator: " ")[0])
        let month = Int(dateFormatter.string(from: date).split(separator: " ")[1])
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let newDate = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: newDate)!
        
        // Number of days in a month
        let numDays = range.count
        
        dateFormatter.dateFormat = "e"
        
        var labels: [UILabel] = [] // Cast them into UILabels later
        
        for i in calendarItems {
            if let newI = i as? UIStackView {
                labels += newI.arrangedSubviews as! [UILabel]
            }
        }
        
        var startIndex = Int(dateFormatter.string(from: newDate))! - 2
        
        // Handle Sunday
        if startIndex < 0 {
            startIndex = 6
        }
        
        // Selected date
        dateFormatter.dateFormat = "d"
        let day = Int(dateFormatter.string(from: date))
        
        for index in 0...labels.count - 1 {
            labels[index].backgroundColor = UIColor(named: "Carlie White")
            labels[index].textColor = UIColor(named: "Carl and Shannen")
            labels[index].isUserInteractionEnabled = true
            
            
            let tapped = UITapGestureRecognizer()
            tapped.addTarget(self, action: #selector(tappedCalendarDate(sender:)))
            labels[index].addGestureRecognizer(tapped)
            
            if index >= startIndex && index - startIndex < numDays {
                labels[index].text = "\(index - startIndex + 1)"
                
                if day == index - startIndex + 1 {
                    // We hit jackpot man
                    labels[index].backgroundColor = UIColor(named: "Carl and Shannen")
                    labels[index].textColor = UIColor(named: "Carlie White")
                    
                    labels[index].layer.cornerRadius = labels[index].frame.height / 2
                    labels[index].clipsToBounds = true
                }
            } else {
                labels[index].text = ""
            }
        }
    }
    
    func notification(_ interval: TimeInterval) {
        let date = Date().addingTimeInterval(interval) // in seconds
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M"
        let month = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "yyyy"
        let year = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "d"
        let day = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "h"
        let hour = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "m"
        let minute = Int(dateFormatter.string(from: date))!
        
        dateFormatter.dateFormat = "s"
        let second = Int(dateFormatter.string(from: date))!
        
        self.notifManager.notifications = [
            NotificationStruct(
                id: "\(post.title)",
                title: "Announcer Reminder",
                body: "\(post.title)",
                datetime: DateComponents(calendar:
                    Calendar.current, year: year, month: month, day: day, hour: hour, minute: minute, second: second))
        ]
        notifManager.schedule()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
