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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func notification(_ interval: TimeInterval) {
        var date = Date().addingTimeInterval(interval) // in seconds
        var dateFormatter = DateFormatter()
        
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
