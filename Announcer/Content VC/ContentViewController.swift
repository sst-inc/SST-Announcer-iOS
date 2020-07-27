//
//  ContentViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit
import SafariServices
import URLEmbeddedView

class ContentViewController: UIViewController {
    
    /// Handles updating AnnouncementVC when dismissing to reload tableView
    var onDismiss: (() -> Void)?
    
    /// Called when a label is selected to update AnnouncementVC and show results for filter
    var filterUpdated: (() -> Void)?

    /// Current font size used in post
    var currentScale: CGFloat = GlobalIdentifier.defaultFontSize {
        didSet {
            // Ensuring that currentScale are within the limits
            
            if currentScale < GlobalIdentifier.minimumFontSize {
                // Handling when it goes below minimum font size
                currentScale = GlobalIdentifier.minimumFontSize
                
            } else if currentScale > GlobalIdentifier.maximumFontSize {
                // Handling when it goes above maximum font size
                currentScale = GlobalIdentifier.maximumFontSize
                
            }
        }
    }
    
    /// Latest haptic feedback played for `ScrollSelection`
    var playedHaptic = 0
    
    ///
    var attributedContent: NSMutableAttributedString?
    
    /// `ScrollSelection` multiplier used to calculate each stage
    let scrollSelectionMultiplier: CGFloat = 37.5
    
    var isDark = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    // Accessibility Increase Text Size
    @IBOutlet weak var defaultFontSizeButton: UIButton!
    @IBOutlet var increaseTextSizeGestureRecognizer: UIPinchGestureRecognizer!
    
    // Header Buttons
    @IBOutlet weak var safariButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // Links and labels section
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var linksView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    
    // - Collection Views
    @IBOutlet weak var linksCollectionView: UICollectionView!
    @IBOutlet weak var labelsCollectionView: UICollectionView!
    
    // - Overall stack view
    @IBOutlet weak var linksAndLabelStackView: UIStackView!
    
    @IBOutlet weak var hardToSeeButton: UIButton!
    
    @IBOutlet weak var loadingContentButton: UIButton!
    
    var fullScreen = true
    
    /// Getting the post
    var post: Post! {
        didSet {
            // Escaping to main thread to update user interface with new content
            DispatchQueue.main.async {
                
                self.contentTextView.setContentOffset(.zero, animated: true)
                
                // Updating content
                self.updateContent()
            }
        }
    }
    
    /// Handling if a post is pinned
    var isPinned = false
    
    /// Stores links from post
    var links: [Links] = [] {
        didSet {
            // Handle duplicated links
            links.removeDuplicates()
            
            // Updating user interface
            // Requires main thread
            DispatchQueue.main.async {
                // Reload linksCollectionView
                self.linksCollectionView.reloadData()
                
                // Ensuring that there are links
                if self.links.count > 0 {
                    // Unhide seperators and linksView
                    
                    self.linksView.isHidden = false
                    self.seperatorView.isHidden = self.labelsView.isHidden
                } else {
                    // Hide seperator
                    self.seperatorView.isHidden = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Getting the current scale from UserDefaults
        // If there is nothing present, use the defaultFontSize from GlobalIdentifier
        // Otherwise, use the userdefaults value
        currentScale = UserDefaults.standard.float(forKey: UserDefaultsIdentifiers.textScale.rawValue) == 0 ? GlobalIdentifier.defaultFontSize : CGFloat(UserDefaults.standard.float(forKey: UserDefaultsIdentifiers.textScale.rawValue))
        
        // Updating currentScale on user defaults
        // This is to handle a case where the currentScale on UserDefaults is nil
        UserDefaults.standard.set(currentScale, forKey: UserDefaultsIdentifiers.textScale.rawValue)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        linksCollectionView.dragDelegate = self
        linksCollectionView.dragInteractionEnabled = true
        
        labelsCollectionView.dragDelegate = self
        labelsCollectionView.dragInteractionEnabled = true
        
        // Adding pointer interactions
        // Only avaliable for iOS 13.4 and up
        if #available(iOS 13.4, *) {
            shareButton.addInteraction(UIPointerInteraction(delegate: self))
            pinButton.addInteraction(UIPointerInteraction(delegate: self))
            safariButton.addInteraction(UIPointerInteraction(delegate: self))
        }
        
        // If user is in dark mode, ask user if they want to switch to light to see the post clearly
        if traitCollection.userInterfaceStyle == .dark {
            hardToSeeButton.isHidden = false
        } else {
            hardToSeeButton.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSize),
                                               name: UserDefaults.didChangeNotification,
                                               object: nil)
        
        if !I.phone {
            loadingContentButton.isHidden = true
        }
        
    }
    
    func updateContent() {
        // Render HTML from String
        // Handle WebKit requirements by showing an error
        
        // Check if need to show message
        let showError = I.phone || (splitViewController as? SplitViewController)?.announcementVC.searchField.text == ""
        
        if post.content.contains("webkitallowfullscreen=\"true\"") || (attributedContent?.string.lowercased() ?? "").contains("error") && showError {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: ErrorMessages.postRequiresWebKit.title,
                                              message: ErrorMessages.postRequiresWebKit.description,
                                              preferredStyle: .alert)
                
                // Open post in safari, post requires webkit
                let openInSafari = UIAlertAction(title: "Open in Safari", style: .default, handler: { (_) in
                    self.openPostInSafari(UILabel())
                })
                
                alert.addAction(openInSafari)
                
                alert.preferredAction = openInSafari
                
                // Close post
                alert.addAction(UIAlertAction(title: "Close Post", style: .cancel, handler: { (_) in
                    if I.phone {
                        // Handling dismissing from Navigation Controller
                        self.navigationController?.popViewController(animated: true)
                        
                        // Handling dismissing from Peek and Pop
                        self.dismiss(animated: true)
                    }
                }))
                
                DispatchQueue.main.async {
                    // Present alert
                    self.present(alert, animated: true)
                }
            }
            
        } else {
            // Getting HTML content
            let content = post.content
            
            // Converting HTML content to NSAttributedString
            // Receiving attributedContent from previous VC, if it doesnt exist, just load it
            let attr = attributedContent ?? content.htmlToAttributedString
            
            // Adding font and background color that support dark mode
            attr?.addAttribute(.font, value: UIFont.systemFont(ofSize: currentScale, weight: .medium), range: NSRange.init(location: 0, length: (attr?.length)!))
            attr?.addAttribute(.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: (attr?.length)!))
            
            // Optimising for iOS 13 dark mode
            attr?.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: (attr?.length)!))
            
            DispatchQueue.main.async {
                // Set the attributed text
                self.contentTextView.attributedText = attr
            }
            
        }
        
        // Update labels/textview with data
        let attrTitle = NSMutableAttributedString(string: post.title)
        // Find the [] and just make it like red or something
        
        // Make square brackets colored
        let indicesStart = attrTitle.string.indicesOf(string: "[")
        let indicesEnd = attrTitle.string.indicesOf(string: "]")
        
        // Determine which one is smaller (start indices or end indices)
        if (indicesStart.count >= (indicesEnd.count) ? indicesStart.count : indicesEnd.count) > 0 {
            for i in 1...(indicesStart.count >= indicesEnd.count ? indicesStart.count : indicesEnd.count) {
                
                let start = indicesStart[i - 1]
                let end = indicesEnd[i - 1]
                
                // [] colors will be Grey 1
                // @shannen why these color names man
                let bracketStyle : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: GlobalColors.blueTint, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .semibold)]
                
                attrTitle.addAttributes(bracketStyle, range: NSRange(location: start, length: end - start + 2))
            }
        }
        
        
        // Format date as "1 Jan 2019"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        
        // Escape to main thread to update user interface
        DispatchQueue.main.async {
            // Update textLabel with attributed text for colored square brackets
            self.titleLabel.attributedText = attrTitle
            
            // Update the page title
            UIApplication.shared.connectedScenes.first?.title = self.post.title
            
            // Update dateLabel with formatted date
            self.dateLabel.text = "Posted on \(dateFormatter.string(from: self.post.date))"
            
            // Reload labels collection view with new data
            self.labelsCollectionView.reloadData()
        }
        
        // Check if item is pinned
        // Update the button to show
        //If is in pinnned
        let pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        
        DispatchQueue.main.async {
            // Fill/Don't fill pin
            if pinnedItems.contains(self.post) {
                // Set the isPinned variable
                self.isPinned = true
                
                // Updating the pinButton image to unpin
                self.pinButton.setImage(Assets.unpin, for: .normal)
            } else {
                // Set the isPinned variable
                self.isPinned = false
                
                // Updating the pinButton image to pin
                self.pinButton.setImage(Assets.pin, for: .normal)
            }
            
            // Set textField delegate
            self.contentTextView.delegate = self
            
            // Hide the labels if there are none
            if self.post.categories.count == 0 {
                self.labelsView.isHidden = true
                self.seperatorView.isHidden = true
            } else {
                self.labelsView.isHidden = false
            }
            
            // Styling default font size button
            // Create a button of corner radius 20
            self.defaultFontSizeButton.layer.cornerRadius = 20
            self.defaultFontSizeButton.clipsToBounds = true
            
            // Hide the button until needed
            self.defaultFontSizeButton.isHidden = true
            
            // Setting corner radii for the scrollSelection buttons to allow for the circular highlight
            self.safariButton.layer.cornerRadius = 25 / 2
            self.shareButton.layer.cornerRadius = 25 / 2
            self.pinButton.layer.cornerRadius = 25 / 2
            
            // Hide links view while loading links
            self.linksView.isHidden = true

        }
        // Load in links asyncronously as it takes a while to generate images etc. for images
        DispatchQueue.global(qos: .utility).async {
            self.links = []
            
            for url in LinkFunctions.getLinksFromPost(post: self.post) {
                OGDataProvider.shared.fetchOGData(withURLString: url.absoluteString) { [weak self] ogData, error in
                    if let _ = error { return }
                    
                    // Getting sourceURL
                    let sourceUrl: String = (ogData.sourceUrl ?? url).absoluteString
                    
                    // Getting page title
                    let pageTitle: String = {
                        // Get newURL
                        let newURL = url.baseURL?.absoluteString ?? url.absoluteString
                        
                        // Handling title for Google Sites
                        if newURL.contains("sites.google.com") {
                            var urlItems = newURL.split(separator: "/")
                            
                            // Remove the first 3 items as it is "https", "sites.google.com" and the domain thing
                            urlItems.removeFirst(3)
                            
                            // Return item
                            return urlItems.joined(separator: "/")
                        }
                        
                        // Setting page title, if not found, just use the URL
                        return ogData.pageTitle ?? newURL
                    }()
                    
                    // Adding thumbnail image
                    let sourceImage: UIImage? = {
                        
                        // Handling imageURL
                        if let imgUrl = ogData.imageUrl {
                            return try? UIImage(data: Data(contentsOf: imgUrl), scale: 1)
                        }
                        return nil
                    }()
                    
                    // Append latest link to links
                    self?.links.append(Links(title: pageTitle, link: sourceUrl, image: sourceImage))
                }
            }
        }

    }
    
    // Handle when view orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if I.phone {
            // Hide linksAndLabelStackView if in landscape; show if in portrait
            linksAndLabelStackView.isHidden = UIDevice.current.orientation.isLandscape && I.phone
        } else {
            if loadingContentButton != nil {
                fullScreen.toggle()
                loadingContentButton.isHidden = fullScreen
            }
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDark ? .lightContent : .default
    }
    
    @IBAction func sharePost(_ sender: Any) {
        
        // Get share URL
        let shareURL = LinkFunctions.getShareURL(with: post)
        
        // Create Activity View Controller (Share screen)
        let shareViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: [])
        
        // Remove unneeded actions
        shareViewController.excludedActivityTypes = [.saveToCameraRoll]

        // Present share sheet
        self.present(shareViewController, animated: true, completion: nil)
    }
    
    @IBAction func hardToSeeButtonPressed(_ sender: Any) {
        if self.hardToSeeButton.title(for: .normal) == "   Reset" {
            self.overrideUserInterfaceStyle = .dark
            self.hardToSeeButton.setTitle("   Hard to Read?", for: .normal)
            self.hardToSeeButton.setImage(UIImage(systemName: "lightbulb"), for: .normal)
        } else {
            self.overrideUserInterfaceStyle = .light
            self.hardToSeeButton.setTitle("   Reset", for: .normal)
            self.hardToSeeButton.setImage(UIImage(systemName: "lightbulb.slash"), for: .normal)
            
        }
        isDark.toggle()
    }
    
    // Go back to previous view controller
    @IBAction func dismiss(_ sender: Any) {
        if I.phone {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func pinnedItem(_ sender: Any) {
        // Toggle pin based on context
        var pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        
        // If item is already pinned, unpin it and vice versa
        if isPinned {
            // Remove the post from the pinned posts
            pinnedItems.remove(at: pinnedItems.firstIndex(of: post)!)
        } else {
            // Add the post to pinned posts
            pinnedItems.append(post)
        }
        
        // Write the pinned announcements to .plist
        PinnedAnnouncements.saveToFile(posts: pinnedItems)
        
        if pinnedItems.contains(post) {
            isPinned = true
            pinButton.setImage(Assets.unpin, for: .normal)
        } else {
            isPinned = false
            pinButton.setImage(Assets.pin, for: .normal)
        }
        
        // Handling splitViewController for iPad/MacCatalyst
        if let splitVC = splitViewController as? SplitViewController {
            
            // Getting announcementVC
            let announcementVC = splitVC.announcementVC!
            
            // Reload data on announcementTableView
            announcementVC.announcementTableView.reloadData()
        } else {
            // Create pop-up to say pinned or unpinned
            let popUpView = UILabel()
            popUpView.textAlignment = .center
            popUpView.frame = CGRect(x: 50, y: 50, width: UIScreen.main.bounds.width - 100, height: 30)
            
            // Corner radius
            popUpView.layer.cornerRadius = 30 / 2
            popUpView.clipsToBounds = true
            
            // Setting text and font
            popUpView.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            popUpView.text = "Post \(isPinned ? "Pinned" : "Unpinned")"
            
            // Setting background styles
            popUpView.backgroundColor = GlobalColors.greyTwo
            
            // Alpha = 0 to allow for a fade in when switching from 0 to 1
            popUpView.alpha = 0
            
            // Adding to subview
            view.addSubview(popUpView)
            
            // Show the pop-up
            UIView.animate(withDuration: 0.5, animations: {
                
                // Animate a fade in of popUpView
                popUpView.alpha = 1
                
            }) { (_) in
                
                // Wait 3 seconds and then auto-dismiss the pop up
                UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseOut, animations: {
                    
                    // Animate a fade out of popUpView
                    popUpView.alpha = 0
                }) { (_) in
                    // When pop-up time is up, remove from stack
                    popUpView.removeFromSuperview()
                }
            }
        }
        
        onDismiss?()
    }
    
    @IBAction func showSideBar(_ sender: Any) {
        if #available(iOS 14.0, *) {
            splitViewController?.show(.primary)
        }
    }
    
    @IBAction func openPostInSafari(_ sender: Any) {
        // Getting shareURL from post
        let link = LinkFunctions.getShareURL(with: post)
        
        if I.mac {
            UIApplication.shared.open(link)
        } else {
            // Creating SafariVC
            let vc = SFSafariViewController(url: link)
            
            // Presenting SafariVC
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func pinchedTextField(_ sender: UIPinchGestureRecognizer) {
        // Creating attributed text
        let attr = NSMutableAttributedString(attributedString: contentTextView.attributedText)
        
        // Calculating the scale
        currentScale = currentScale * sender.scale
        
        // New font size and style
        let font = UIFont.systemFont(ofSize: currentScale, weight: .medium)
        
        // Setting text color using NSAttributedString
        attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: attr.length))
        
        // Setting attributedText on contentTextView
        contentTextView.attributedText = attr
        
        // Updating UserDefaults with the new scale
        UserDefaults.standard.set(currentScale, forKey: UserDefaultsIdentifiers.textScale.rawValue)
        
        if sender.state == .ended || sender.state == .cancelled && sender.scale != 1 {
            
            // Handling when the user stops zooming to show reset button
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                self.defaultFontSizeButton.isHidden = true
            }
        } else {
            if sender.scale != 1 {
                // Hide defaultFontSizeButton
                defaultFontSizeButton.isHidden = false
            } else {
                // Show defaultFontSizeButton
                defaultFontSizeButton.isHidden = true
            }
        }
    }
    
    @objc func updateSize() {
        
        // Updating the current scale of the text
        currentScale = UserDefaults.standard.float(forKey: UserDefaultsIdentifiers.textScale.rawValue) == 0 ? GlobalIdentifier.defaultFontSize : CGFloat(UserDefaults.standard.float(forKey: UserDefaultsIdentifiers.textScale.rawValue))
        
        // 
        DispatchQueue.main.async {
            // New font size and style
            let font = UIFont.systemFont(ofSize: self.currentScale, weight: .medium)
            
            // Creating attributed text
            let attr = NSMutableAttributedString(attributedString: self.contentTextView.attributedText)
            
            // Setting text color using NSAttributedString
            attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: attr.length))
            
            // Setting attributedText on contentTextView
            self.contentTextView.attributedText = attr
        }
    }
    
    // Tapped reset to default font size button
    @IBAction func resetToDefaultFontSize(_ sender: Any) {
        let attr = NSMutableAttributedString(attributedString: contentTextView.attributedText)
        
        // Set currentScale to default font size
        currentScale = GlobalIdentifier.defaultFontSize
        
        // Default font style
        let font = UIFont.systemFont(ofSize: currentScale, weight: .medium)
        
        // Setting font to the whole attributed string
        attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: attr.length))
        
        // Update UserDefaults with new scale
        UserDefaults.standard.set(currentScale, forKey: UserDefaultsIdentifiers.textScale.rawValue)
        
        // Set attributedText to contentTextView
        contentTextView.attributedText = attr
        
        // Hide the button
        defaultFontSizeButton.isHidden = true
    }
    
    // Updating pinned values
    func updatePinned() {
        let pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        if pinnedItems.contains(post) {
            // Item is pinned
            isPinned = true
            
            // Set the image
            pinButton.setImage(Assets.unpin, for: .normal)
        } else {
            // Item is not pinned
            isPinned = false
            
            // Set the image
            pinButton.setImage(Assets.pin, for: .normal)
        }
    }
}
