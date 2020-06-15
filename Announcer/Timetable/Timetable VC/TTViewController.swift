//
//  TTViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 14/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit

class TTViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var timetable: Timetable!
    var lessons: [Lesson]!
    
    var lessonIndex = 0
    
    @IBOutlet weak var updateTimetable: UIButton!
    
    @IBOutlet weak var nowImageView: UIImageView!
    @IBOutlet weak var nowLessonLabel: UILabel!
    @IBOutlet weak var nowDescriptionLabel: UILabel!
    
    @IBOutlet weak var laterImageView: UIImageView!
    @IBOutlet weak var laterLessonLabel: UILabel!
    @IBOutlet weak var laterTeacherLabel: UILabel!
    
    @IBOutlet weak var nowView: UIStackView!
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var laterView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTimetable.layer.cornerRadius = 10
        
        // Dummy Data
        timetable = Timetable(class: "S4-07",
                              timetableImage: Data(),
                              monday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                       Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                       Lesson(identifier: "bio", teacher: "Leong WF", startTime: 36000, endTime: 42000),
                                       Lesson(identifier: "chem", teacher: "Praveena", startTime: 42000, endTime: 45600),
                                       Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 45600, endTime: 49200)],
                              tuesday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                        Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                        Lesson(identifier: "bio", teacher: "Leong WF", startTime: 36000, endTime: 42000),
                                        Lesson(identifier: "chem", teacher: "Praveena", startTime: 42000, endTime: 45600),
                                        Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 45600, endTime: 49200)],
                              wednesday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                          Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                          Lesson(identifier: "bio", teacher: "Leong WF", startTime: 36000, endTime: 42000),
                                          Lesson(identifier: "chem", teacher: "Praveena", startTime: 42000, endTime: 45600),
                                          Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 45600, endTime: 49200)],
                              thursday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                         Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                         Lesson(identifier: "bio", teacher: "Leong WF", startTime: 36000, endTime: 42000),
                                         Lesson(identifier: "chem", teacher: "Praveena", startTime: 42000, endTime: 45600),
                                         Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 45600, endTime: 49200)],
                              friday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                       Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                       Lesson(identifier: "bio", teacher: "Leong WF", startTime: 36000, endTime: 42000),
                                       Lesson(identifier: "chem", teacher: "Praveena", startTime: 42000, endTime: 45600),
                                       Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 45600, endTime: 49200)])
        
        lessons = timetable.monday
        
        timeUpdated()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Check for updates to the timing every second to handle when a new lesson starts or an old one ends
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            self.timeUpdated()
        }
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        // Dismiss directly from the navigation controller to prevent weird issues
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "time", for: indexPath) as! TTTableViewCell
        
        if indexPath.row == 0 {
            cell.topTimelineView.isHidden = true
        }
        cell.bottomTimelineIndicator.backgroundColor = GlobalColors.greyThree
        cell.topTimelineView.backgroundColor = GlobalColors.greyThree
        cell.timelineIndicator.tintColor = GlobalColors.greyThree
        
        
        if indexPath.row == lessons.count - 1 {
            cell.bottomTimelineIndicator.layer.cornerRadius = cell.bottomTimelineIndicator.frame.width / 2
        } else {
            cell.bottomTimelineIndicator.layer.cornerRadius = 0
        }
                
        cell.lesson = lessons[indexPath.row]
        
        return cell
    }
    
    func timeUpdated() {
        // Declaring ongoingLesson as optional as there may not be an ongoing lesson
        var ongoingLesson: Lesson?
        
        var counter = -1
        
        // Getting today's date value, at 00:00 and getting the time interval since now
        // Basically, how many seconds since 00:00
        let todayTimeInterval = Date().timeIntervalSince(Lesson.todayDate)
        
        // Looping through to find the current lesson
        for i in lessons {
            // Adding to the counter because, it is a counter
            counter += 1
            
            // Checking if todayTimeInterval is between startTime and endTime
            // If so, the lesson is currently ongoing
            if todayTimeInterval > i.startTime && todayTimeInterval < i.endTime {
                // When current lesson is found, set it as ongoingLesson and escape out of the loop
                ongoingLesson = i
                
                break
            }
        }
        
        // If the new counter is the same as the old value (stored in lessonIndex), then, it is still on the same lesson
        // Therefore, do nothing and just return to skip the rest of the function
        if counter == lessonIndex { return }
        
        // Update lessonIndex with the new counter value
        lessonIndex = counter
        
        if let ongoingLesson = ongoingLesson {
            let ongoingLessonAttr = Assets.getSubject(ongoingLesson.identifier, font: .systemFont(ofSize: 30))
            
            nowLessonLabel.text = ongoingLessonAttr.1
            nowImageView.image = ongoingLessonAttr.0
            nowDescriptionLabel.text = "Ends in \(todayTimeInterval)"
            
            nowView.isHidden = false
        } else {
            nowLessonLabel.text = "No Lessons"
            nowImageView.image = Assets.home
            nowDescriptionLabel.text = "No ongoing lessons."
            
            nowView.isHidden = true
        }
        
        if lessonIndex < lessons.count {
            // The value which corresponds to the lesson in the lessons array
            // If the ongoingLesson is nil, it means that no lesson is ongoing, therefore, show the first item
            let nextLessonIndex = ongoingLesson == nil ? 0 : lessonIndex + 1
            
            // The next lesson
            let nextLesson = lessons[nextLessonIndex]
            
            // Assets for the next lesson such as the icon and the full name
            let nextLessonAttr = Assets.getSubject(nextLesson.identifier, font: .systemFont(ofSize: 30))
            
            // Updating the UI with the nextLesson
            // - Setting the icon image to the one found from the assets
            laterImageView.image = nextLessonAttr.0
            
            // - Setting the text to the one that is from the assets
            laterLessonLabel.text = nextLessonAttr.1
            
            // - Setting the teacher's name.
            //    - For lessons that the teacher's name is unable to be determined, it will just show nothing in place of the actual name.
            laterTeacherLabel.text = nextLesson.teacher ?? ""
            
            // Ensure that the laterView is not hidden
            laterView.isHidden = false
        } else {
            // Hide the laterView as the lesson is probably over or there are no lessons that day
            laterView.isHidden = true
        }
        
        // Handling the separator view
        // Separator gets hidden when either laterView or nowView is hidden
        separatorView.isHidden = laterView.isHidden || nowView.isHidden
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
