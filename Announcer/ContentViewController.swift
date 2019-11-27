//
//  ContentViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextView!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Update labels/textview with data
        titleLabel.text = post.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        dateLabel.text = "Posted on \(dateFormatter.string(from: post.date))"
        contentTextField.text = post.content
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
