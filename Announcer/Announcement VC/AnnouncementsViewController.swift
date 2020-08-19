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
                
                if self.posts != nil {
                    self.addItemsToCoreSpotlight()
                    
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
        
        // Corner radius for top buttons
        // This is for the scroll selection
        filterButton.layer.cornerRadius = 25 / 2
        reloadButton.tintColor = GlobalColors.greyOne
        
        // Pointer support
        // Add a circle when they hover over button
        if #available(iOS 13.4, *) {
            filterButton.addInteraction(UIPointerInteraction(delegate: self))
        }
        
        // Adding drag and drop support for announcements
        announcementTableView.dragInteractionEnabled = true
        announcementTableView.dragDelegate = self
        
        // Timetable is only supported on iOS 14
        if #available(iOS 14, macOS 11, *) {
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        if I.mac {
            view.backgroundColor = .clear
            announcementTableView.backgroundColor = .clear
        }
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.uturn.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.uturn.left")
        
        setUpFeedbackButton()
        
        title = NSLocalizedString("APP_NAME",
                                  comment: "Announcer")
        
        searchResults = AnnouncementSearch(labelsDidSet: {
            self.updateFilterButton()
        })
    }
    
    func setUpFeedbackButton() {
        let feedback = FeedbackButton(frame: .zero)
        
        feedback.translatesAutoresizingMaskIntoConstraints = false

        let feedbackConstraints = [NSLayoutConstraint(item: feedback,
                                                      attribute: .trailing,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .trailing,
                                                      multiplier: 1,
                                                      constant: -20),
                                   NSLayoutConstraint(item: feedback,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .bottomMargin,
                                                      multiplier: 1,
                                                      constant: -20),
                                   NSLayoutConstraint(item: feedback,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: 50)]
        
        feedback.parent = self
        
        view.addSubview(feedback)
        view.addConstraints(feedbackConstraints)
        
        self.feedback = feedback
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
//        loadingIndicator.startAnimating()
//        reloadButton.isHidden = true
        
        DispatchQueue.global(qos: .background).async {
            self.pinned = PinnedAnnouncements.loadFromFile() ?? []
            self.posts = Fetch.posts(with: self)
            
            // Reset cache
            self.cachedContent = .init(repeating: nil, count: 25)
            
            DispatchQueue.main.async {
//                self.loadingIndicator.stopAnimating()
//                self.reloadButton.isHidden = false
            }
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
    
    /// Get filter view controller and open it up
    func openFilter() {
        // Getting navigation controller from filter storyboard
        if let filterNVC = Storyboards.filter.instantiateInitialViewController() as? UINavigationController {

            // Get filterViewController from navigationController
            if let filterVC = filterNVC.children.first as? FilterTableViewController {

                // Set onDismiss actions that will run when we dismiss the other vc
                // this void should reload tableview etc.
                filterVC.onDismiss = {
                    // Set search bar text
                    self.searchField.text = "[\(filter)]"

                    // Reload table view with new content
                    self.announcementTableView.reloadData()

                    // Run search function
                    self.searchBar(self.searchField, textDidChange: "[\(filter)]")

                    // Reset filters
                    filter = ""
                }
            }

            // Present filter navigation controller
            self.present(filterNVC, animated: true)
        }
    }
    
    /// Save items to spotlight search
    func addItemsToCoreSpotlight() {
        
        /// So that it does not crash when `posts` gets forced unwrapped
        /// Handles instances when `posts` is `nil`, for instance, when reloading
        if posts == nil {
            return
        }
        
        /// `posts` converted to `CSSearchableItems`
        let items: [CSSearchableItem] = posts.map({ post in
            let attributeSet =  CSSearchableItemAttributeSet(itemContentType: kUTTypeHTML as String)
            
            /// Setting the title of the post
            attributeSet.title = post.title
            
            /// Set the keywords for the `CSSearchableItem` to make it easier to find on Spotlight Search
            attributeSet.keywords = post.categories
            
            /// Setting the content description so when the user previews the
            /// announcement through spotlight search, they can see the content description
            let content = post.content.condenseLinebreaks()
            attributeSet.contentDescription = content.htmlToAttributedString?.htmlToString
            
            // Creating the searchable item from the attributesSet
            let item = CSSearchableItem(uniqueIdentifier: "\(post.title)",
                                        domainIdentifier: Bundle.main.bundleIdentifier!,
                                        attributeSet: attributeSet)
            
            // Setting the expiration date to distant future
            // So that it will not expire, at least not in 2000 years
            item.expirationDate = Date.distantFuture
            
            // Return the item
            return item
        })
        
        // Index the items
        CSSearchableIndex.default().indexSearchableItems(items) { error in
            // Make sure there is no error indexing everything
            if let error = error {
                // An error occurred when indexing
                // I do not exactly have a back-up plan on what to do in this case
                // Mainly just have the spotlight search not work
                print("Indexing error: \(error.localizedDescription)")
            } else {
                // Items were indexed. We did it.
                print("Search items successfully indexed!")
            }
        }
    }
    
    /// Reload filter with new filter query
    func reloadFilter() {
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
    
    /// Select `searchField` to bring up keyboard
    @objc func startSearching() {
        // Set search field as first responder to bring up keyboard
        searchField.becomeFirstResponder()
    }
}
