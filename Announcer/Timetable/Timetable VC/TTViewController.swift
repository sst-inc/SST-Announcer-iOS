//
//  TTViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 14/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import WidgetKit

@available(iOS 14, macOS 11, *)
class TTViewController: UIViewController {

    var timetable: Timetable!
    var lessons: [Lesson]!
    var todayLessons: [Lesson]!
    
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
    
    @IBOutlet weak var todayButton: UIButton!
    
    @IBOutlet weak var ongoingUpNextStackView: UIStackView!
    
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
    
    // StackView Items
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var settingDateStackView: UIStackView!
    @IBOutlet weak var timetableTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTimetable.layer.cornerRadius = 10
        todayButton.layer.cornerRadius = 10
        
        // Commented out Dummy Data
        // Dummy Data
        // swiftlint:disable all
        timetable = Timetable(class: "S4-07",
                              timetableImage: Data(),
                              monday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 32400, endTime: 36000),
                                       Lesson(identifier: "break", startTime: 36000, endTime: 38400),
                                       Lesson(identifier: "bio", teacher: "Leong WF", startTime: 38400, endTime: 42000),
                                       Lesson(identifier: "math", teacher: "Janet Tan", startTime: 42000, endTime: 45600),
                                       Lesson(identifier: "chem", teacher: "Praveena", startTime: 45600, endTime: 49200),
                                       Lesson(identifier: "cce", teacher: "Eunice Lim / Samuel Lee", startTime: 49200, endTime: 52800)],
                              tuesday: [Lesson(identifier: "ss", teacher: "Seth Tan", startTime: 28800, endTime: 32400),
                                        Lesson(identifier: "break", startTime: 32400, endTime: 34800),
                                        Lesson(identifier: "cl", startTime: 34800, endTime: 38400),
                                        Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 38400, endTime: 43200),
                                        Lesson(identifier: "break", startTime: 43200, endTime: 45600),
                                        Lesson(identifier: "chem", teacher: "Praveena", startTime: 45600, endTime: 49200),
                                        Lesson(identifier: "math", teacher: "Janet Tan", startTime: 49200, endTime: 52800),
                                        Lesson(identifier: "ch(ge)", teacher: "Alvin Tan", startTime: 52800, endTime: 56400)],
                              wednesday: [Lesson(identifier: "el", teacher: "Eunice Lim", startTime: 2400, endTime: 3000)],
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
        // swiftlint:enable all
        // If not using dummy data
        // Let's see if this works
//        timetable = Timetable.get()
        
        timetable.save()
        
        // Set up selected date to be the current date, this is to call the didSet there to update the labels and all
        selectedDate = Date()
        
        // Get the current day and update the lessons array
        dayChanged()
        
        // Add an observer to handle when the day gets changed
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dayChanged),
                                               name: .NSCalendarDayChanged,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dayChanged),
                                               name: UIApplication.significantTimeChangeNotification,
                                               object: nil)
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            // Hide everything
            bottomSeparatorView.isHidden = true
            settingDateStackView.isHidden = true
            timetableTableView.isHidden = true
        } else {
            // Show everything
            bottomSeparatorView.isHidden = false
            settingDateStackView.isHidden = false
            timetableTableView.isHidden = false
            
        }
    }
    
    override var keyCommands: [UIKeyCommand]? {
        // Go to Next Post
        let leftArrow = UIKeyCommand(input: UIKeyCommand.inputLeftArrow,
                                     modifierFlags: [],
                                     action: #selector(yesterdayButtonClicked(_:)))
        let rightArrow = UIKeyCommand(input: UIKeyCommand.inputRightArrow,
                                      modifierFlags: [],
                                      action: #selector(tomorrowButtonClicked(_:)))
        
        return [leftArrow, rightArrow]
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
    
    @IBAction func todayButtonClicked(_ sender: Any) {
        selectedDate = Lesson.getTodayDate()
        dayChanged()
    }
    
    @IBAction func updateTimetableButtonClicked(_ sender: Any) {
        
        // Getting navigation controller
        if let ttNavigationController = navigationController as? TTNavigationViewController {
            
            // Run the fetchTimetables function to get the timetables
            ttNavigationController.fetchTimetables()
        }
        
        // Perform segue to TTSetUpViewController
        performSegue(withIdentifier: "setup", sender: nil)
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
        
        if Calendar.current.isDateInToday(selectedDate) {
            todayLessons = lessons
            
            if todayLessons == [] {
                // Hide views because it is the weekends
                ongoingUpNextStackView.isHidden = true
                bottomSeparatorView.isHidden = true
            } else {
                // Ensure the views are not hidden, if they need to be, they will get hidden later
                ongoingUpNextStackView.isHidden = false
                bottomSeparatorView.isHidden = false
            }
            
            // Animate the button hiding with a wipe
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.todayButton.isHidden = true
                }
            }
        } else {
            
            // Animate the button showing with a wipe
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.todayButton.isHidden = false
                }
            }
        }
        
        // After updating the lessons, update the timings
        // This will allow it to update the UI
        timeUpdated()
        
        DispatchQueue.main.async {
            self.timetableTableView.reloadData()
        }
    }
    
    func timeUpdated() {
        // Handling weekends
        // If user uses announcer on weekends, they should know that no data will appear
        if todayLessons == [] { return }
        
        // Declaring ongoingLesson as optional as there may not be an ongoing lesson
        var ongoingLesson: Lesson?
        
        var counter = -1
        
        // Getting today's date value, at 00:00 and getting the time interval since now
        // Basically, how many seconds since 00:00
        let todayTimeInterval = Date().timeIntervalSince(Lesson.getTodayDate())
        
        // Looping through to find the current lesson
        for i in todayLessons {
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
            
            let start = Lesson.convert(time: ongoingLesson.startTime)
            let end = Lesson.convert(time: ongoingLesson.endTime)
            
            nowDescriptionLabel.text = "From \(start) to \(end)"
        } else {
            nowLessonLabel.text = "No Lessons"
            nowImageView.image = Assets.home
            nowDescriptionLabel.text = "There are no ongoing lessons."
        }
        
        if lessonIndex! < todayLessons.count - 1 {
            // The value which corresponds to the lesson in the lessons array
            // If the ongoingLesson is nil, it means that no lesson is ongoing, therefore, show the first item
            let nextLessonIndex = ongoingLesson == nil ? 0 : lessonIndex! + 1
            
            // The next lesson
            let nextLesson = todayLessons[nextLessonIndex]
            
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
        
        // Get the date of the first lesson.
        // This will be used if the ongoing lesson = nil
        let firstLessonDate = Lesson.getTodayDate().advanced(by: todayLessons[0].startTime)
        
        if ongoingLesson == nil && firstLessonDate.timeIntervalSinceNow > 0 {
            // Since there are no ongoing lessons, and it is before the first lesson
            // The app fires the timer at the start of first lesson to update interface
            let timer = Timer(fire: firstLessonDate, interval: 0, repeats: false) { (_) in
                // Time updated should update the interface with the new lesson
                self.timeUpdated()
            }
            
            // Add timer to run loop
            RunLoop.main.add(timer, forMode: .common)
        } else if let ongoingLesson = ongoingLesson {
            // Get the the for the ongoing lesson
            let lessonDate = Lesson.getTodayDate().advanced(by: ongoingLesson.endTime)
            
            // Create timer to fire once lesson ends
            // This will fix the 
            let timer = Timer(fire: lessonDate, interval: 0, repeats: false) { (_) in
                self.timeUpdated()
            }
            
            RunLoop.main.add(timer, forMode: .common)
        } else if ongoingLesson == lessons.last {
            let lessonDate = Lesson.getTodayDate().advanced(by: lessons.last!.endTime)
            
            // Create timer to fire once lesson ends
            // This will fix the
            let timer = Timer(fire: lessonDate, interval: 0, repeats: false) { (_) in
                self.timeUpdated()
            }
            
            RunLoop.main.add(timer, forMode: .common)
        }
        
        // Handling the separator view
        // Separator gets hidden when either laterView or nowView is hidden
        separatorView.isHidden = laterView.isHidden || nowView.isHidden
        
        // Reload timetable's data
        timetableTableView.reloadData()
        
        // Scroll to lesson index
        timetableTableView.scrollToRow(at: IndexPath(row: lessonIndex ?? 0, section: 0), at: .top, animated: true)
    }
}
