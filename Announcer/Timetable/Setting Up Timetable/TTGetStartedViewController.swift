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
        
        let timetableNVC = navigationController as! TTNavigationViewController
        if let pdf = timetableNVC.timetablePDF {
            let search = pdf.findString(classTextField.text!, withOptions: .literal)
            if search.count > 0 {
                let pageSelection = search.first
                
                page = pageSelection!.pages.first
                
                performSegue(withIdentifier: "showPDF", sender: nil)
            } else {
                let alert = UIAlertController(title: "Invalid Class", message: "The class, \(classTextField.text!) is either invalid or not found.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                
                self.present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Loading Timetables", message: "Timetables are loading. Please try again later.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                self.doneButtonPressed(self)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            }))
            
            self.present(alert, animated: true)
        }
        
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
