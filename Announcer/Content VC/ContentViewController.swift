//
//  ContentViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit
import SafariServices

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

    /// Attributed content when it is sent over
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

    // - Labels for localization
    @IBOutlet weak var linksLabel: UILabel!
    @IBOutlet weak var labelsLabel: UILabel!
    
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

                if self.contentTextView != nil {
                    self.contentTextView.setContentOffset(.zero, animated: true)
                }

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
                if self.linksCollectionView != nil {
                    self.linksCollectionView.reloadData()
                }
                
                // Ensuring that there are links
                if self.links.count > 0 {
                    // Unhide seperators and linksView

                    if self.linksView != nil {
                        self.linksView.isHidden = false
                    }
                    
                    if self.seperatorView != nil {
                        self.seperatorView.isHidden = self.labelsView.isHidden
                    }
                } else {
                    // Hide seperator
                    if self.seperatorView != nil {
                        self.seperatorView.isHidden = true
                    }
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
        let userDefaultsFloat = UserDefaults.standard.float(forKey: UserDefaultsIdentifiers.textScale.rawValue)
        currentScale = userDefaultsFloat == 0 ? GlobalIdentifier.defaultFontSize : CGFloat(userDefaultsFloat)

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

        loadingContentButton.isHidden = true
        
        loadLocalization()
    }
    
    func loadLocalization() {
        linksLabel.text = NSLocalizedString("POST_LINKS",
                                            comment: "Links")
        
        labelsLabel.text = NSLocalizedString("POST_LABELS",
                                             comment: "Labels")
        
        hardToSeeButton.setTitle(NSLocalizedString("POST_HARDTOREAD_DEFAULT",
                                                   comment: "Hard to Read?"),
                                 for: .normal)
    }

    // Handle when view orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if I.phone {
            // Hide linksAndLabelStackView if in landscape; show if in portrait
            linksAndLabelStackView.isHidden = UIDevice.current.orientation.isLandscape && I.phone
        } else {
            
            if loadingContentButton != nil {
                
                fullScreen = !(UIApplication.shared.windows.first?.frame.size == size)
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
            
            self.hardToSeeButton.setTitle(NSLocalizedString("POST_HARDTOREAD_DEFAULT",
                                                            comment: "Hard to Read?"),
                                          for: .normal)
            
            self.hardToSeeButton.setImage(UIImage(systemName: "lightbulb"), for: .normal)
        } else {
            self.overrideUserInterfaceStyle = .light
            
            self.hardToSeeButton.setTitle(NSLocalizedString("POST_HARDTOREAD_SELECTED",
                                                            comment: "Hard to Read?"),
                                          for: .normal)
            
            self.hardToSeeButton.setImage(UIImage(systemName: "lightbulb.slash"), for: .normal)
        }
        isDark.toggle()
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
            
            let localizedKey = isPinned ? "POST_PIN_LONG" : "POST_UNPIN_LONG"
            
            let popUpLocalized = NSLocalizedString(localizedKey,
                                                   comment: "Unpin/pin")
            
            popUpView.text = popUpLocalized
            
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
            let safariVC = SFSafariViewController(url: link)

            // Presenting SafariVC
            present(safariVC, animated: true, completion: nil)
        }
    }

    @IBAction func pinchedTextField(_ sender: UIPinchGestureRecognizer) {
        // Creating attributed text
        let attr = NSMutableAttributedString(attributedString: contentTextView.attributedText)
        
        // Calculating the scale
        currentScale *= sender.scale

        // New font size and style
        let font = UIFont.systemFont(ofSize: currentScale, weight: .medium)

        // Setting text color using NSAttributedString
        attr.enumerateAttribute(.font,
                                in: NSRange(location: 0, length: attr.length),
                                options: .init(rawValue: 0)) { (value, range, _) in
            if let font = value as? UIFont {
                
                if font.fontName.lowercased().contains("bold") {
                    attr.addAttribute(.font,
                                      value: UIFont.systemFont(ofSize: currentScale,
                                                               weight: .bold),
                                      range: range)
                } else if font.fontName.lowercased().contains("italics") {
                    attr.addAttribute(.font,
                                      value: UIFont.italicSystemFont(ofSize: currentScale),
                                      range: range)
                    
                } else {
                    attr.addAttribute(.font,
                                      value: UIFont.systemFont(ofSize: currentScale,
                                                               weight: .medium),
                                      range: range)
                }
            }
        }

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

        // Setting font to the whole attributed string
        attr.enumerateAttribute(.font,
                                in: NSRange(location: 0, length: attr.length),
                                options: .init(rawValue: 0)) { (value, range, _) in
            if let font = value as? UIFont {
                
                if font.fontName.lowercased().contains("bold") {
                    attr.addAttribute(.font,
                                      value: UIFont.systemFont(ofSize: currentScale,
                                                               weight: .bold),
                                      range: range)
                } else if font.fontName.lowercased().contains("italics") {
                    attr.addAttribute(.font,
                                      value: UIFont.italicSystemFont(ofSize: currentScale),
                                      range: range)
                    
                } else {
                    attr.addAttribute(.font,
                                      value: UIFont.systemFont(ofSize: currentScale,
                                                               weight: .medium),
                                      range: range)
                }
            }
        }

        // Update UserDefaults with new scale
        UserDefaults.standard.set(currentScale, forKey: UserDefaultsIdentifiers.textScale.rawValue)

        // Set attributedText to contentTextView
        contentTextView.attributedText = attr

        // Hide the button
        defaultFontSizeButton.isHidden = true
    }
}
