//
//  TimetableNavigationViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 10/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import PDFKit
import Alamofire

class TTNavigationViewController: UINavigationController {

    var timetablePDF: PDFDocument? {
        didSet {
            print("hello")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Getting Timetable storyboards
        let storyboard = Storyboards.timetable
        
        // Getting timetable view controller
        let timetable = storyboard.instantiateViewController(identifier: "Timetable")
        
        // Getting setUp view controller
        let setUp = storyboard.instantiateViewController(identifier: "SetUp")
        
        // Setting which viewcontrolller to present
        if Timetable.get() == nil {
            // If there are no timetables, show set up screen
            self.viewControllers = [setUp]
            
            // Fetching timetables from Google Drive
            fetchTimetables()
        } else {
            // Otherwise, show the timetable screen
            self.viewControllers = [timetable]
            
        }
    }
    
    /// Fetching timetables from Google Drive
    func fetchTimetables() {
        // Do it on another thread because it is not a good idea to do it here
        DispatchQueue.global(qos: .default).async {
            
            // Getting the apiKey from the Keys struct
            // NOTE: The keys are just placeholders on Git
            // because sharing keys are a terrible idea
            let apiKey = Keys.driveAPI
            
            // Finding possible posts which could be timetables
            var possiblePosts = Fetch.values().filter {                $0.categories.contains("Timetable") || $0.categories.contains("timetable")
            }
            
            // Sort the possiblePosts by date to find the latest timetable
            possiblePosts.sort { (first, second) -> Bool in
                first.date.distance(to: second.date) < 0
            }
            
            // Getting the first post
            let post = possiblePosts.first
            
            // Getting the drive link
            // Sort through the links and finding the first one that contains "drive.google.com"
            let driveLink = LinkFunctions.getLinksFromPost(post: post!).filter { (link) -> Bool in
                link.absoluteString.contains("drive.google.com")
            }[0]
            
            // Getting the path components of drive URL to extract the fileID
            let driveComponents = driveLink.pathComponents
            
            // Getting the fileID from the Drive URL
            let fileID = driveComponents[driveComponents.count - 2]
            
            // Adding the drive URL to the Google REST API
            let url = URL(string: "https://www.googleapis.com/drive/v3/files/\(fileID)?prettyPrint=true&key=\(apiKey)")!
            
            // Using Alamofire to get the PDF documents from Google Drive
            AF.request(url, method: .get, parameters: ["alt":"media"]).validate().responseJSON { response in
                
                // Setting the timetablePDF
                self.timetablePDF = PDFDocument(data: response.data!)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
