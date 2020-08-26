//
//  TTVCTableView.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 14, *)
extension TTViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lessons.count == 0 {
            let defaultAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
            
            let attrString = NSMutableAttributedString(string: "😴\n\nThere are no lessons on \(selectedDate.day()).",
                                                       attributes: defaultAttr)
            
            attrString.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: 48, weight: .bold),
                                    range: NSRange(location: 0, length: 3))
            
            tableView.setEmptyState(attrString)
        } else {
            tableView.restore()
        }
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "time", for: indexPath) as? TTTableViewCell {
            // Hide the top part of the timeline if it is the first row, this is to create a convincing timeline
            cell.topTimelineView.isHidden = indexPath.row == 0
            
            // Hide the bottom of timeline when done
            cell.bottomTimelineIndicator.isHidden = indexPath.row == lessons.count - 1
            
            // Set the selected date, this is going to be used to determine the current date
            //
            // This solves the issue of having the timeline highlighting on
            // days that have already passed or are far in the future
            cell.selectedDate = selectedDate
            
            // Resetting timeline colors
            cell.topTimelineView.backgroundColor = GlobalColors.greyThree
            cell.timelineIndicator.tintColor = GlobalColors.greyThree
            cell.bottomTimelineIndicator.backgroundColor = GlobalColors.greyThree
            
            // Setting the cell's lesson
            cell.lesson = lessons[indexPath.row]
            
            return cell

        } else {
            fatalError("Unknown cell")
        }
    }
}
