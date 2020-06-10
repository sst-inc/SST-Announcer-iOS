//
//  TimetableViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 10/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import Alamofire
import PDFKit

class TimetableViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStartedButton.layer.cornerRadius = 10
        /*
         GET https://www.googleapis.com/drive/v3/files/123WC1OVbc-WapEO9kZZ53Rr4L29zJLkv?prettyPrint=true&key=[YOUR_API_KEY] HTTP/1.1

         Authorization: Bearer [YOUR_ACCESS_TOKEN]
         Accept: application/json

         */
        // Do any additional setup after loading the view.
        let apiKey = Keys.driveAPI
        
        // This is the fileID for the current timetable, it is a placeholder
        let fileID = "123WC1OVbc-WapEO9kZZ53Rr4L29zJLkv"
        
        let url = URL(string: "https://www.googleapis.com/drive/v3/files/\(fileID)?prettyPrint=true&key=\(apiKey)")!
        
        AF.request(url, method: .get, parameters: ["alt":"media"]).validate().responseJSON { response in
            
            debugPrint(response)
            
            let pdf = PDFDocument.init(data: response.data!)
            
        }
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
