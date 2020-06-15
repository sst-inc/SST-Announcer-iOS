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
    
    var lessonIndex: Int?
    
    var selectedDate = Date() {
        didSet {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "EEEE, d MMM"
            
            let str = formatter.string(from: selectedDate)
            
            if Calendar.current.isDateInToday(selectedDate) {
                dateLabel.text = str + " (Today)"
            } else {
                dateLabel.text = str
            }
        }
    }
    
    @IBOutlet weak var timetableTableView: UITableView!
    
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
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTimetable.layer.cornerRadius = 10
        
        // Commented out Dummy Data
        // Dummy Data
        timetable = Timetable(class: "S4-07",
                              timetableImage: Data(),
                              monday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                       Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                       Lesson(identifier: "bio", teacher: "Leong WF", startTime: 38400, endTime: 42000),
                                       Lesson(identifier: "math", teacher: "Janet Tan", startTime: 42000, endTime: 45600),
                                       Lesson(identifier: "chem", teacher: "Praveena", startTime: 45600, endTime: 49200),
                                       Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 49200, endTime: 52800)],
                              tuesday: [Lesson(identifier: "s&w", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                        Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                        Lesson(identifier: "chem", teacher: "Leong WF", startTime: 38400, endTime: 42000),
                                        Lesson(identifier: "bio", teacher: "Praveena", startTime: 42000, endTime: 45600),
                                        Lesson(identifier: "ss", teacher: "Eunice Lim / Samuel Lee", startTime: 45600, endTime: 49200)],
                              wednesday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                          Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                          Lesson(identifier: "bio", teacher: "Leong WF", startTime: 38400, endTime: 42000),
                                          Lesson(identifier: "chem", teacher: "Praveena", startTime: 42000, endTime: 45600),
                                          Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 45600, endTime: 49200)],
                              thursday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                         Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                         Lesson(identifier: "bio", teacher: "Leong WF", startTime: 38400, endTime: 42000),
                                         Lesson(identifier: "chem", teacher: "Praveena", startTime: 42000, endTime: 45600),
                                         Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 45600, endTime: 49200)],
                              friday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                       Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                       Lesson(identifier: "bio", teacher: "Leong WF", startTime: 38400, endTime: 42000),
                                       Lesson(identifier: "chem", teacher: "Praveena", startTime: 42000, endTime: 45600),
                                       Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 45600, endTime: 49200)])
        
//        timetable = UserDefaults.standard.object(forKey: "timetable") as? Timetable
        
        // Set up selected date to be the current date, this is to call the didSet there to update the labels and all
        selectedDate = Date()
        
        // Get the current day and update the lessons array
        dayChanged()
        
        // Add an observer to handle when the day gets changed
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dayChanged),
                                               name: .NSCalendarDayChanged, object: nil)
        
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
    
    @IBAction func tomorrowButtonClicked(_ sender: Any) {
        // Add 24 hours (86400 seconds) to time
        selectedDate.addTimeInterval(86400)
        dayChanged()
    }
    
    @IBAction func yesterdayButtonClicked(_ sender: Any) {
        // Subtract 24 hours (86400 seconds) to time
        selectedDate.addTimeInterval(-86400)
        dayChanged()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lessons.count == 0 {
            let defaultAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
            
            let attrString = NSMutableAttributedString(string: "😴\n\nThere are no lessons today.", attributes: defaultAttr)
            
            attrString.addAttribute(.font, value: UIFont.systemFont(ofSize: 48, weight: .bold), range: NSRange(location: 0, length: 3))
            
            tableView.setEmptyState(attrString)
        } else {
            tableView.restore()
        }
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "time", for: indexPath) as! TTTableViewCell
        
        // Hide the top part of the timeline if it is the first row, this is to create a convincing timeline
        cell.topTimelineView.isHidden = indexPath.row == 0
        
        // Hide the bottom of timeline when done
        cell.bottomTimelineIndicator.isHidden = indexPath.row == lessons.count - 1
        
        // Set the selected date, this is going to be used to determine the current date
        // This solves the issue of having the timeline highlighting on days that have already passed or are far in the future
        cell.selectedDate = selectedDate
        
        // Resetting timeline colors
        cell.topTimelineView.backgroundColor = GlobalColors.greyThree
        cell.timelineIndicator.tintColor = GlobalColors.greyThree
        cell.bottomTimelineIndicator.backgroundColor = GlobalColors.greyThree
        
        cell.lesson = lessons[indexPath.row]
        
        return cell
    }
    
    @objc func dayChanged() {
        switch Calendar.current.component(.weekday, from: selectedDate) {
        case 2:
            lessons = timetable.monday
            
        case 3:
            lessons = timetable.tuesday
            
        case 4:
            lessons = timetable.wednesday
            
        case 5:
            lessons = timetable.thursday
            
        case 6:
            lessons = timetable.friday
            
        default:
            // No what, why are u using Announcer Timetable on weekends
            lessons = []
        }
        
        // After updating the lessons, update the timings
        // This will allow it to update the UI
        timeUpdated()
        
        timetableTableView.reloadData()
    }
    
    func timeUpdated() {
        // Handling weekends
        // If user uses announcer on weekends, they should know that no data will appear
        if lessons == [] { return }
        
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
            nowDescriptionLabel.text = "From \(Lesson.convert(time: ongoingLesson.startTime)) to \(Lesson.convert(time: ongoingLesson.endTime))"
            
            nowView.isHidden = false
        } else {
            nowLessonLabel.text = "No Lessons"
            nowImageView.image = Assets.home
            nowDescriptionLabel.text = "No ongoing lessons."
            
            nowView.isHidden = true
        }
        
        if lessonIndex! < lessons.count - 1 {
            // The value which corresponds to the lesson in the lessons array
            // If the ongoingLesson is nil, it means that no lesson is ongoing, therefore, show the first item
            let nextLessonIndex = ongoingLesson == nil ? 0 : lessonIndex! + 1
            
            // The next lesson
            let nextLesson = lessons[nextLessonIndex]
            
            // Assets for the next lesson such as the icon and the full name
            let nextLessonAttr = Assets.getSubject(nextLesson.identifier, font: .systemFont(ofSize: 30))
            
            // Updating the UI with the nextLesson
            // - Setting the icon image to the one found from the assets
            laterImageView.image = nextLessonAttr.0
            
            // - Setting the text to the one that is from the assets
            laterLessonLabel.text = nextLessonAttr.1
            
            // - Setting the start at label's text
            //    - This will show what time the lesson starts at
            //    - e.g. "Starts at 9:00am"
            laterTeacherLabel.text = "Starts at \(Lesson.convert(time: nextLesson.startTime))"
            
            // Ensure that the laterView is not hidden
            laterView.isHidden = false
        } else {
            // Hide the laterView as the lesson is probably over or there are no lessons that day
            laterView.isHidden = true
        }
        
        // Handling the separator view
        // Separator gets hidden when either laterView or nowView is hidden
        separatorView.isHidden = laterView.isHidden || nowView.isHidden
        
        // Reload timetable's data
        timetableTableView.reloadData()
        
        // Scroll to lesson index
        timetableTableView.scrollToRow(at: IndexPath(row: lessonIndex!, section: 0), at: .top, animated: true)
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
