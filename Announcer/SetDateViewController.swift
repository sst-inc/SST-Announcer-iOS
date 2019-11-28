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
    var reminderTime: TimeInterval = 0 // in seconds
    
    @IBOutlet weak var backgroundRedView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tomorrowDateLabel: UILabel!
    @IBOutlet weak var twoDaysDateLabel: UILabel!
    @IBOutlet weak var nextWeekDateLabel: UILabel!
    @IBOutlet weak var customDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        containerView.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        backgroundRedView.alpha = 0
        
        // Load dates in
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, h:mm a"
        
        tomorrowDateLabel.text = formatter.string(from: date.addingTimeInterval(86400))
        twoDaysDateLabel.text = formatter.string(from: date.addingTimeInterval(86400*2))
        nextWeekDateLabel.text = formatter.string(from: date.addingTimeInterval(86400*7))
        customDateLabel.text = formatter.string(from: date.addingTimeInterval(86400*30))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.backgroundRedView.alpha = 0.75
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        // Set notification timing
        notification(reminderTime)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundRedView.alpha = 0
        }) { (_) in
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundRedView.alpha = 0
        }) { (_) in
            self.dismiss(animated: true)
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
            Notification(
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
