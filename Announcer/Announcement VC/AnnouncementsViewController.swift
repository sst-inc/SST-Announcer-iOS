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
    
    // Stores pinned posts
    var pinned = [Post]()
    
    @IBOutlet weak var announcementTableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide navigation controller
        // Navigation controller is only used for segue animations
        self.navigationController?.navigationBar.isHidden = true
        
        // Fetch Blog Posts
        DispatchQueue.global(qos: .background).async {
            self.posts = fetchBlogPosts(self)
        }
        
        // Load Pinned Comments
        pinned = PinnedAnnouncements.loadFromFile() ?? []
        
        searchField.setTextField(color: UIColor(named: "Carlie White")!)
        
        if #available(iOS 13.0, *) {} else {
            // Fallback on earlier versions
            registerForPreviewing(with: self, sourceView: announcementTableView)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            self.pinned = PinnedAnnouncements.loadFromFile() ?? []
            self.posts = fetchBlogPosts(self)
        }
        
        print("reloading")
    }
}
