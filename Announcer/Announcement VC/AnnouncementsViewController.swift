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
    
    // Stores searchresults if searched with tags
    var searchTags = [Post]()
    
    // Haptics play at each segment when scrolling up
    var playedHaptic = 0
    
    @IBOutlet weak var announcementTableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    
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
        
        // Get Content VC
        if let vc = segue.destination as? ContentViewController {
            // Send the post over to that vc
            vc.post = selectedItem
        }
        
        /// Get filter VC
        // Use an if let to ensure we are referring to the correct viewcontroller
        // We need go through a navigation controller layer
        if let nvc = segue.destination as? UINavigationController {
            
            // nvc.children.first is the viewcontroller
            let vc = nvc.children.first as! FilterTableViewController
            
            // Set onDismiss actions that will run when we dismiss the other vc
            // this void should reload tableview etc.
            vc.onDismiss = {
                print(filter)
                self.searchField.text = "[\(filter)]"
                self.announcementTableView.reloadData()
                self.searchBar(self.searchField, textDidChange: "[\(filter)]")
            }
        }
    }
    @IBAction func sortWithLabels(_ sender: Any) {
        performSegue(withIdentifier: "labels", sender: nil)
    }

    @IBAction func reload(_ sender: Any) {
        self.posts = nil
        
        DispatchQueue.global(qos: .background).async {
            self.posts = fetchBlogPosts()
        }
        
        print("reloading")
    }
}
