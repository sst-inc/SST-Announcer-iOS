//
//  TimetableGetStartedViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 10/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import PDFKit

class TTGetStartedViewController: UIViewController, UITextFieldDelegate {

    // Time for alerts but in seconds
    let timeOfAlerts: [TimeInterval] = [0, 300, 600, 900, 1200, 1800]
    var selectedAlerts: [TimeInterval] = []
    
    var page: PDFPage?
    
    @IBOutlet weak var formStackView: UIStackView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var classTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doneButton.layer.cornerRadius = 10
        
        for i in 0...timeOfAlerts.count - 1 {
            let optionView =  formStackView.arrangedSubviews[i + 7]
            let imageView = optionView.subviews.first as! UIImageView
            
            imageView.image = UIImage(systemName: "circle")
            
            optionView.tag = i
            
            // Adding a gesture recognizer
            let gestureRecognizer = UITapGestureRecognizer()
            
            // Adding the target to handle tap on the options
            gestureRecognizer.addTarget(self, action: #selector(tappedOnOptions(sender:)))
            
            // Adding the gesture recognizer
            optionView.addGestureRecognizer(gestureRecognizer)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        classTextField.becomeFirstResponder()
    }
    
    @objc func tappedOnOptions(sender: UITapGestureRecognizer) {
        // Getting the optionView from sender's view
        let optionView = sender.view!
        
        // Getting the imageView from optionView
        // The checkmark icon thing
        let imageView = optionView.subviews.first as! UIImageView
        
        // Getting the time of alert from the current option
        let time = timeOfAlerts[optionView.tag]
        
        if selectedAlerts.contains(time) {
            imageView.image = UIImage(systemName: "circle")
            selectedAlerts.removeAll { $0 == time }
        } else {
            imageView.image = UIImage(systemName: "checkmark.circle.fill")
            selectedAlerts.append(time)
        }
    }
    
    @IBAction func classTextFieldEdited(_ sender: UITextField) {
        if let lastCharacter = sender.text!.last {
            switch sender.text?.count {
            case 0, 1:
                sender.text = "S"
            case 2:
                if lastCharacter.isNumber && sender.tag != 1 {
                    sender.text! += "-"
                    sender.tag = 1
                } else {
                    sender.text?.removeLast()
                    sender.tag = 0
                }
            case 6:
                // Max 5 characters
                // Stop editing at 5
                sender.text?.removeLast()
            default:
                if !lastCharacter.isNumber {
                    sender.text?.removeLast()
                }
            }
        } else {
            sender.text = "S"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "S"
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = "S"
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
    
    @IBAction func tappedView(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if !regexCheck(with: classTextField.text!) {
            // Fails regular expression check
            showFailRegexCheckAlert()
        }
        
        // Getting the timetable navigation controller
        let timetableNVC = navigationController as! TTNavigationViewController
        
        // Checking if the PDF exists
        if let pdf = timetableNVC.timetablePDF {
            
            // Searcg through pdf to find the classTextField's text
            let search = pdf.findString(classTextField.text!, withOptions: .literal)
            
            if search.count > 0 {
                // If it exists, send the page over to the next viewController
                
                // Getting the PDF selection
                let pageSelection = search.first
                
                // Setting the page that the selection came from
                page = pageSelection!.pages.first
                
                // Moving over to the next view controller
                performSegue(withIdentifier: "showPDF", sender: nil)
            } else {
                // Class not found
                showClassNotFoundAlert()
            }
        } else {
            // The timetable is still loading
            showLoadingTimetableAlert()
        }
        
    }
    
    func regexCheck(with str: String) -> Bool {
        // Creating regex
        let regex = try! NSRegularExpression(pattern: "S[1-9]-[0-9][0-9]")
        
        // Creating range for regex
        let range = NSRange(location: 0, length: str.utf16.count)
        
        // Getting first match
        let matches = regex.firstMatch(in: str, options: [], range: range)
        
        // Return if the matches exist
        return matches != nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let dest = segue.destination as? TTPreviewViewController, let page = page {
            dest.page = page
            dest.`class` = classTextField.text
        }
    }


}
