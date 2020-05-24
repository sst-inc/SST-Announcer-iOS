//
//  AnnouncementsTableViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class AnnouncementsViewController: UIViewController {
    
    /// Store the selected post found on didSelect
    var selectedItem: Post!
    
    /// Stores all post for this viewcontroller
    var posts: [Post]! {
        didSet {
            DispatchQueue.main.async {
                self.announcementTableView.reloadData()
                self.addItemsToCoreSpotlight()
            }
        }
    }
    
    /// Stores search results in the title
    var searchFoundInTitle = [Post]()
    
    /// Stores search results in body of post
    var searchFoundInBody = [Post]()
    
    /// Stores search results if searched with labels
    var searchLabels = [Post]()
    
    /// Haptics play at each segment when scrolling up
    var playedHaptic = 0
    
    /// Stores pinned posts
    var pinned = [Post]()
    
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
        searchField.setTextField(color: UIColor(named: "background")!)
        
        // Peek & Pop for below iOS 13
        if #available(iOS 13.0, *) {
        } else {
            // Fallback on earlier versions
            registerForPreviewing(with: self, sourceView: announcementTableView)
        }
        
        // Corner radius for top buttons
        // This is for the scroll selection
        filterButton.layer.cornerRadius = 25 / 2
        reloadButton.layer.cornerRadius = 27.5 / 2
    }
    
    // Handles changing from dark to light or vice-versa
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        searchField.setTextField(color: UIColor(named: "background")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Handling when a tag is selected from the ContentViewController
        if filter != "" {
            // Setting search bar text
            self.searchField.text = "[\(filter)]"
            
            // Reloading announcementTableView with the new search field tet
            self.announcementTableView.reloadData()
            
            // Updating search bar
            self.searchBar(self.searchField, textDidChange: "[\(filter)]")
            
            // Reset filter
            filter = ""
        } else {
            self.announcementTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ContentViewController {
            
            // Sending the post to contentVC
            dest.post = selectedItem
            
            // Handling filter updates in case user taps filter from contentVC
            dest.filterUpdated = {
                self.searchField.text = "[\(filter)]"
                self.announcementTableView.reloadData()
                self.searchBar(self.searchField, textDidChange: "[\(filter)]")
            }
        }
    }
    
    // Open Filter with Labels
    @IBAction func sortWithLabels(_ sender: Any) {
        resetScroll()
        openFilter()
    }

    // Reload announcements
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
    }
    
    /// Receiving post from push notifications
    func receivePost(with post: Post) {
        selectedItem = post
        
        let vc = getContentViewController(for: IndexPath(row: 0, section: 0))
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Get filter view controller and open it up
    func openFilter() {
        let filterStoryboard = UIStoryboard(name: "Filter", bundle: nil)
        
        let nvc = filterStoryboard.instantiateInitialViewController() as! UINavigationController
        
        let vc = nvc.children.first as! FilterTableViewController
        
        // Set onDismiss actions that will run when we dismiss the other vc
        // this void should reload tableview etc.
        vc.onDismiss = {
            self.searchField.text = "[\(filter)]"
            self.announcementTableView.reloadData()
            self.searchBar(self.searchField, textDidChange: "[\(filter)]")
        }
        
        self.present(nvc, animated: true)
    }
    
    func addItemsToCoreSpotlight() {
        
        /// So that it does not crash when `posts` gets forced unwrapped
        if posts == nil {
            return
        }
        
        /// `posts` converted to `CSSearchableItems`
        let items: [CSSearchableItem] = posts.map({ post in
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributeSet.title = post.title
            attributeSet.contentDescription = post.content.condenseLinebreaks().htmlToString

            return CSSearchableItem(uniqueIdentifier: "\(post.title)",
                domainIdentifier: Bundle.main.bundleIdentifier!,
                attributeSet: attributeSet)
        })
        
        // Index the items
        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search items successfully indexed!")
            }
        }
    }
}
