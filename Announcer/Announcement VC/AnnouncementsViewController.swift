//
//  AnnouncementsTableViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class AnnouncementsViewController: UIViewController {
    
    // Store the selected post found on didSelect
    var selectedItem: Post!
    
    // Stores all post for this viewcontroller
    var posts: [Post]! {
        didSet {
            DispatchQueue.main.async {
                self.announcementTableView.reloadData()
            }
        }
    }
    
    // Stores searchresults in the title
    var searchFoundInTitle = [Post]()
    
    // Stores searchresults in body of post
    var searchFoundInBody = [Post]()
    
    @IBOutlet weak var announcementTableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide navigation controller
        // Navigation controller is only used for segue animations
        self.navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.global(qos: .background).async {
            self.posts = fetchBlogPosts()
        }
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
