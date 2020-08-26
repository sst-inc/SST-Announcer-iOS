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
import WhatsNewKit

class AnnouncementsViewController: UIViewController {
    
    /// Store the selected post found on didSelect
    var selectedItem: Post!
    
    /// Stores all post for this viewcontroller
    var posts: [Post]! {
        didSet {
            DispatchQueue.main.async {
                self.announcementTableView.reloadData()
                
                if self.posts != nil {
                    self.addItemsToCoreSpotlight()
                    self.badgeItems()
                    
                    // Handling iPadOS splitVC
                    if let splitVC = self.splitViewController as? SplitViewController {
                        
                        // Get first or selected cell
                        let cell = self.tableView(self.announcementTableView,
                                                  cellForRowAt: self.selectedPath) as? AnnouncementTableViewCell
                        
                        cell?.setSelected(true, animated: true)
                        
                        // Set content of posts
                        splitVC.contentVC.post = cell?.post
                        
                        // Show contentVC
                        splitVC.showDetailViewController(splitVC.contentVC, sender: nil)
                    }
                }
            }
        }
    }
    
    var searchResults = AnnouncementSearch(labelsDidSet: {})
    
    /// Haptics play at each segment when scrolling up
    var playedHaptic = 0
    
    /// Stores pinned posts
    var pinned = [Post]()
    
    /// Cache Post Content
    var cachedContent: [NSAttributedString?] = .init(repeating: nil, count: 25)
    
    /// Scroll selection multiplier used to control scroll height
    let scrollSelectionMultiplier: CGFloat = 40
    
    /// Selected Path
    var selectedPath = IndexPath(row: 0, section: 0)
    
    /// Search Queues
    var searchQueue: DispatchWorkItem?
    
    var feedback: FeedbackButton!
    
    @IBOutlet weak var timetableButton: UIBarButtonItem!
    @IBOutlet weak var announcementTableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide navigation controller
        // Navigation controller is only used for segue animations
        
        // Fetch Blog Posts
        DispatchQueue.global(qos: .background).async {
            self.posts = Fetch.posts(with: self)
        }
        
        // Load Pinned Comments
        pinned = PinnedAnnouncements.loadFromFile() ?? []
        
        // Adding drag and drop support for announcements
        announcementTableView.dragInteractionEnabled = true
        announcementTableView.dragDelegate = self
        
        // Set up navigation controller, feedback button and preset whats new if needed
        setUp()
        
        searchResults = AnnouncementSearch(labelsDidSet: {
            self.updateFilterButton()
        })
    }
    
    func updateFilterButton() {
        if searchResults.labels == nil {
            DispatchQueue.main.async {
                self.filterButton.setImage(Assets.filter, for: .normal)
            }
            
        } else {
            DispatchQueue.main.async {
                self.filterButton.setImage(Assets.filterFill, for: .normal)
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        reloadFilter()
    }
    
    // Open Filter with Labels
    @IBAction func sortWithLabels(_ sender: Any) {
        // Resetting scroll selection
        // Handles when a user selects this button through scroll selection
        self.resetScroll()
        
        // Open up the filter view controller
        openFilter()
    }

    // Reload announcements
    @IBAction func reload(_ sender: Any) {
        self.posts = nil
        
        DispatchQueue.global(qos: .background).async {
            self.pinned = PinnedAnnouncements.loadFromFile() ?? []
            self.posts = Fetch.posts(with: self)
            
            // Reset cache
            self.cachedContent = .init(repeating: nil, count: 25)
        }
    }
    
    @available(iOS 14, macOS 11, *)
    @IBAction func openTimetable(_ sender: Any) {
        if let vc = Storyboards.timetable.instantiateInitialViewController() as? TTNavigationViewController {
            present(vc, animated: true)
        }
    }
    
    /// Receiving post from push notifications
    func receivePost(with post: Post) {
        selectedItem = post
        
        /// iPad uses splitVC, therefore, when recieving a post, it must handle it though splitVC
        /// Getting contentVC from splitViewController but handling it as an optional
        /// as there is a chance user is on iPhone which will make `splitViewController`'s value `nil`
        if let contentVC = (splitViewController as? SplitViewController)?.contentVC {
            // Setting post in contentVC to itself
            contentVC.post = post
            
        } else {
            DispatchQueue.main.async {
                /// Getting contentViewController with `post`
                let contentVC = self.getContentViewController(with: post)
                
                // Push navigation controller
                self.navigationController?.pushViewController(contentVC, animated: true)
            }
        }
    }
        
    /// Select `searchField` to bring up keyboard
    @objc func startSearching() {
        // Set search field as first responder to bring up keyboard
        searchField.becomeFirstResponder()
    }
}
