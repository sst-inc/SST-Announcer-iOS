//
//  TTGetStartedAlerts.swift
//  Announcer
//
//  Created by JiaChen(: on 21/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension TTGetStartedViewController {
    func showFailRegexCheckAlert() {
        // Present an alert to inform the user that their format is wrong
        let alert = UIAlertController(title: "Incorrectly formatted class", message: "Please ensure that your class is formatted as \"SX-XX\", for example, \"S4-07\"", preferredStyle: .alert)
        
        // Add just one action that says "OK" because there is no other choice
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        
        // Present alert
        self.present(alert, animated: true)
    }
    
    func showLoadingTimetableAlert() {
        // Show an alert to say that it is loading
        let alert = UIAlertController(title: "Loading Timetables", message: "Timetables are loading. Please try again later.", preferredStyle: .alert)
        
        // Add an action that just says try again. It should just check if it exists again
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            
            // Running doneButtonPressed to see if it exist
            self.doneButtonPressed(self)
        }))
        
        // Add another action to cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        
        // Present the alert
        self.present(alert, animated: true)
    }
    
    func showClassNotFoundAlert() {
        // Present an alert to inform the user
        let alert = UIAlertController(title: "Invalid Class", message: "The class, \(classTextField.text!) is either invalid or not found.", preferredStyle: .alert)
        
        // Add just one action that says "OK" because there is no other choice
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        
        // Present alert
        self.present(alert, animated: true)
    }
}
