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
    
    // Stores searchresults if searched with labels
    var searchLabels = [Post]()
    
    // Haptics play at each segment when scrolling up
    var playedHaptic = 0
    
    // Stores pinned posts
    var pinned = [Post]()
    
    let borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
    
    @IBOutlet weak var announcementTableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
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
        
        // Setting the searhField's text field color
        searchField.setTextField(color: UIColor(named: "Carlie White")!)
        
        // Peek
        if #available(iOS 13.0, *) {} else {
            // Fallback on earlier versions
            registerForPreviewing(with: self, sourceView: announcementTableView)
        }
        
        filterButton.layer.cornerRadius = 25 / 2
        reloadButton.layer.cornerRadius = 27.5 / 2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        searchField.setTextField(color: UIColor(named: "Carlie White")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if filter != "" {
            self.searchField.text = "[\(filter)]"
            self.announcementTableView.reloadData()
            self.searchBar(self.searchField, textDidChange: "[\(filter)]")
            filter = ""
        } else {
            self.announcementTableView.reloadData()
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
                self.searchField.text = "[\(filter)]"
                self.announcementTableView.reloadData()
                self.searchBar(self.searchField, textDidChange: "[\(filter)]")
            }
        }
        
        if let dest = segue.destination as? ContentViewController {
            dest.post = selectedItem
            dest.filterUpdated = {
                self.searchField.text = "[\(filter)]"
                self.announcementTableView.reloadData()
                self.searchBar(self.searchField, textDidChange: "[\(filter)]")
            }
        }
    }
    @IBAction func sortWithLabels(_ sender: Any) {
        resetScroll()
        performSegue(withIdentifier: "labels", sender: nil)
    }

    @IBAction func reload(_ sender: Any) {
        self.posts = nil
        loadingIndicator.startAnimating()
        reloadButton.isHidden = true
        
        DispatchQueue.global(qos: .background).async {
            self.pinned = PinnedAnnouncements.loadFromFile() ?? []
            self.posts = fetchBlogPosts(self)
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.reloadButton.isHidden = false
            }
        }
        
        print("reloading")
    }
    
    func receivePost(with post: Post) {
        selectedItem = post
        
        let vc = getContentViewController(for: IndexPath(row: 0, section: 0))
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AnnouncementsViewController: NSUserActivityDelegate {
    func userActivityWillSave(_ userActivity: NSUserActivity) {
        print(userActivity.title! + " was saved")
    }
}
