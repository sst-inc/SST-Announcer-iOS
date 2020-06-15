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
        
        let storyboard = Storyboards.timetable
        let timetable = storyboard.instantiateViewController(identifier: "Timetable")
        let setUp = storyboard.instantiateViewController(identifier: "SetUp")
        
        if UserDefaults.standard.object(forKey: "timetable") == nil {
            self.viewControllers = [timetable]
        } else {
            self.viewControllers = [setUp]
        }
        
        
        DispatchQueue.global(qos: .default).async {
            let apiKey = Keys.driveAPI
            
            // This is the fileID for the current timetable, it is a placeholder
            
            var possiblePosts = Fetch.values().filter { $0.categories.contains("Timetable") || $0.categories.contains("timetable")
            }
            possiblePosts.sort { (first, second) -> Bool in
                first.date.distance(to: second.date) < 0
            }
            
            let post = possiblePosts.first
            
            // Getting the driveLink
            let driveLink = LinkFunctions.getLinksFromPost(post: post!).filter { (link) -> Bool in
                link.absoluteString.contains("drive.google.com")
            }[0]
            
            // Getting the path components of drive URL to extract the fileID
            let driveComponents = driveLink.pathComponents
            
            let fileID = driveComponents[driveComponents.count - 2]
            
            let url = URL(string: "https://www.googleapis.com/drive/v3/files/\(fileID)?prettyPrint=true&key=\(apiKey)")!
            
            AF.request(url, method: .get, parameters: ["alt":"media"]).validate().responseJSON { response in
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
