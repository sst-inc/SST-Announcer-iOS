//
//  AnnouncementsTableViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class AnnouncementsViewController: UIViewController {

    var selectedItem: Post!
    var posts: [Post]!
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide navigation controller
        // Navigation controller is only used for segue animations
        self.navigationController?.navigationBar.isHidden = true
        
        posts = fetchBlogPosts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue to ContentVC
        if let vc = segue.destination as? ContentViewController {
            vc.post = selectedItem
        }
    }
    @IBAction func sortWithLabels(_ sender: Any) {
        performSegue(withIdentifier: "labels", sender: nil)
    }
}
