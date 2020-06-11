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
        
        DispatchQueue.global(qos: .default).async {
            let apiKey = Keys.driveAPI
            
            // This is the fileID for the current timetable, it is a placeholder
            let fileID = "1wwSNCuWOjsLgjrmo5lUNPMC9ArzV-GWU"
            
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
