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
    
    /// `ScrollSelection` multiplier used to calculate each stage
    let scrollSelectionMultiplier: CGFloat = 37.5
    
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
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var labelsView: UIView!
    @IBOutlet weak var linksView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    
    @IBOutlet weak var linksCollectionView: UICollectionView!
    @IBOutlet weak var labelsCollectionView: UICollectionView!
    
    @IBOutlet weak var linksAndLabelStackView: UIStackView!
    
    var post: Post! {
        didSet {
            DispatchQueue.main.async {
                self.updateContent()
            }
        }
    }
    
    var isPinned = false
    
    var links: [Links] = [] {
        didSet {
            // Handle duplicated links
            links.removeDuplicates()
            
            // Reload linksCollectionView
            DispatchQueue.main.async {
                self.linksCollectionView.reloadData()
                
                if self.links.count > 0 {
                    self.linksView.isHidden = false
                    self.seperatorView.isHidden = self.labelsView.isHidden
                } else {
                    self.seperatorView.isHidden = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        currentScale = UserDefaults.standard.float(forKey: UserDefaultsIdentifiers.textScale.rawValue) == 0 ? GlobalIdentifier.defaultFontSize : CGFloat(UserDefaults.standard.float(forKey: UserDefaultsIdentifiers.textScale.rawValue))
        
        UserDefaults.standard.set(currentScale, forKey: UserDefaultsIdentifiers.textScale.rawValue)
        
        // Hide back button if on splitVC
        if splitViewController != nil {
            backButton.isHidden = true
        }
        
        // Adding pointer interactions
        if #available(iOS 13.4, *) {
            shareButton.addInteraction(UIPointerInteraction(delegate: self))
            pinButton.addInteraction(UIPointerInteraction(delegate: self))
            safariButton.addInteraction(UIPointerInteraction(delegate: self))
        }
    }
    
    func updateContent() {
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
        
        DispatchQueue.main.async {
            self.titleLabel.attributedText = attrTitle
            self.dateLabel.text = "Posted on \(dateFormatter.string(from: self.post.date))"
            
            self.labelsCollectionView.reloadData()
        }
        
        // Render HTML from String
        // Handle JavaScript
        if post.content.contains("webkitallowfullscreen=\"true\"") {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: ErrorMessages.postRequiresWebKit.title,
                                              message: ErrorMessages.postRequiresWebKit.description,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Open in Safari", style: .default, handler: { (_) in
                    self.openPostInSafari(UILabel())
                }))
                
                alert.addAction(UIAlertAction(title: "Close Post", style: .cancel, handler: { (_) in
                    // Handling dismissing from Navigation Controller
                    self.navigationController?.popViewController(animated: true)
                    
                    // Handling dismissing from Peek and Pop
                    self.dismiss(animated: true)
                }))
                
                self.present(alert, animated: true)
            }
            
        } else {
            let content = post.content
            
            let attr = content.htmlToAttributedString
            
            attr?.addAttribute(.font, value: UIFont.systemFont(ofSize: currentScale, weight: .medium), range: NSRange.init(location: 0, length: (attr?.length)!))
            attr?.addAttribute(.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: (attr?.length)!))
            
            // Optimising for iOS 13 dark mode
            attr?.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: (attr?.length)!))
            
            contentTextView.attributedText = attr
        }
        
        // Check if item is pinned
        // Update the button to show
        //If is in pinnned
        let pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        
        // Fill/Don't fill pin
        if pinnedItems.contains(post) {
            isPinned = true
            pinButton.setImage(Assets.unpin, for: .normal)
        } else {
            isPinned = false
            pinButton.setImage(Assets.pin, for: .normal)
        }
        
        // Set textField delegate
        contentTextView.delegate = self
        
        // Hide the labels if there are none
        if post.categories.count == 0 {
            labelsView.isHidden = true
            seperatorView.isHidden = true
        } else {
            labelsView.isHidden = false
        }
        
        // Styling default font size button
        defaultFontSizeButton.layer.cornerRadius = 20
        defaultFontSizeButton.clipsToBounds = true
        defaultFontSizeButton.isHidden = true
        
        // Setting corner radii for the scrollSelection buttons to allow for the circular highlight
        safariButton.layer.cornerRadius = 25 / 2
        backButton.layer.cornerRadius = 25 / 2
        shareButton.layer.cornerRadius = 25 / 2
        pinButton.layer.cornerRadius = 25 / 2
        
        // Hide links view while loading links
        linksView.isHidden = true
        
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
        
        // Hide linksAndLabelStackView if in landscape; show if in portrait
        linksAndLabelStackView.isHidden = UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom == .phone
    }
    
    @IBAction func sharePost(_ sender: Any) {
        
        // Get share URL
        let shareURL = LinkFunctions.getShareURL(with: post)
        
        // Create Activity View Controller (Share screen)
        let shareViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: [])
        
        // Remove unneeded actions
        shareViewController.excludedActivityTypes = [.saveToCameraRoll]
        
        // Setting the source view
        shareViewController.popoverPresentationController?.sourceView = self.view
        
        // Present share sheet
        self.present(shareViewController, animated: true, completion: nil)
    }
    
    // Go back to previous view controller
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            let announcementVC = splitVC.announcementViewController!
            
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
    
    @IBAction func openPostInSafari(_ sender: Any) {
        // Getting shareURL from post
        let link = LinkFunctions.getShareURL(with: post)
        
        // Creating SafariVC
        let vc = SFSafariViewController(url: link)
        
        // Presenting SafariVC
        present(vc, animated: true, completion: nil)
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
