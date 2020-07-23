//
//  SplitViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 4/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    // Getting contentVC from storyboards
    var contentVC = Storyboards.content.instantiateInitialViewController() as! ContentViewController
    
    // announcementVC is set through viewDidLoad
    var announcementVC: AnnouncementsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setting announcerViewController
        let navigationController = children[0] as! UINavigationController
        announcementVC = navigationController.visibleViewController as? AnnouncementsViewController
        
        // Show loading vc
        // Loading VC will be replaced by contentVC when the data has finished loading in AnnouncementVC
        show(LoadingViewController(), sender: nil)
        
        // Setting the display mode to be automatic
        self.preferredDisplayMode = .twoBesideSecondary
        
        contentVC = self.children[1].children.first as! ContentViewController
        
        // Set background style as sidebar
        self.primaryBackgroundStyle = .sidebar
    }
    
    override var keyCommands: [UIKeyCommand]? {
        // Search for announcements using Cmd F
        let search = UIKeyCommand(title: "Search",
                                  image: UIImage(systemName: "magnifyingglass"),
                                  action: #selector(startSearching),
                                  input: "f",
                                  modifierFlags: .command,
                                  discoverabilityTitle: "Search",
                                  state: .mixed)
        
        
        // Reload announcements using Cmd R
        let reload = UIKeyCommand(title: "Reload",
                                  image: UIImage(systemName: "arrow.clockwise"),
                                  action: #selector(reloadPosts),
                                  input: "r",
                                  modifierFlags: .command,
                                  discoverabilityTitle: "Reload",
                                  state: .mixed)
        
        // Filter announcements using Cmd Shift F
        let filter = UIKeyCommand(title: "Filter Posts",
                                  image: Assets.filter,
                                  action: #selector(filterPosts),
                                  input: "f",
                                  modifierFlags: [.command, .shift],
                                  discoverabilityTitle: "Filter Posts",
                                  state: .mixed)
        
        // Share announcement using Cmd S
        let share = UIKeyCommand(title: "Share",
                                  image: Assets.share,
                                  action: #selector(sharePost),
                                  input: "s",
                                  modifierFlags: .command,
                                  discoverabilityTitle: "Share Post",
                                  state: .mixed)
        
        // Pin announcement using Cmd P
        let pin = UIKeyCommand(title: "Pin",
                               image: Assets.pin,
                               action: #selector(pinPost),
                               input: "p",
                               modifierFlags: .command,
                               discoverabilityTitle: "Pin Post",
                               state: .mixed)
        
        // Open announcement in Safari using Cmd Shift S
        let safari = UIKeyCommand(title: "Open in Safari",
                                  image: Assets.safari,
                                  action: #selector(openSafari),
                                  input: "s",
                                  modifierFlags: [.command, .shift],
                                  discoverabilityTitle: "Open in Safari",
                                  state: .mixed)
        
        // Open App's settings using Cmd ,
        let settings = UIKeyCommand(title: "Settings",
                                  image: Assets.settings,
                                  action: #selector(openSettings),
                                  input: ",",
                                  modifierFlags: [.command],
                                  discoverabilityTitle: "Settings",
                                  state: .mixed)
        
        // Go to Next Post
        let downArrow = UIKeyCommand(input: UIKeyCommand.inputDownArrow,
                                     modifierFlags: [],
                                     action: #selector(nextPost))
        
        // Go to Previous Post
        let upArrow = UIKeyCommand(input: UIKeyCommand.inputUpArrow,
                                   modifierFlags: [],
                                   action: #selector(previousPost))

        // Zooming Post
        let zoomIn = UIKeyCommand(title: "Zoom In",
                                  image: Assets.zoomIn,
                                  action: #selector(zoomInPost),
                                  input: "=",
                                  modifierFlags: [.command],
                                  discoverabilityTitle: "Zoom In",
                                  state: .mixed)
        
        let zoomOut = UIKeyCommand(title: "Zoom Out",
                                   image: Assets.zoomOut,
                                   action: #selector(zoomOutPost),
                                   input: "-",
                                   modifierFlags: [.command],
                                   discoverabilityTitle: "Zoom Out",
                                   state: .mixed)
        
        let resetZoom = UIKeyCommand(title: "Reset Zoom",
                                     image: Assets.resetZoom,
                                     action: #selector(resetPostZoom),
                                     input: "1",
                                     modifierFlags: [.command],
                                     discoverabilityTitle: "Reset Zoom",
                                     state: .mixed)
        
        return [settings, search, filter, reload,
                share, safari, pin,
                zoomIn, zoomOut, resetZoom,
                downArrow, upArrow]
    }

    // Selecting search bar
    @objc func startSearching() {
        // Get announcementVC and make searchField first responder
        // This will push the keyboard and select the search field
        announcementVC.searchField.becomeFirstResponder()
    }
    
    // Reload posts
    @objc func reloadPosts() {
        // Get announcementVC and call the reload @IBAction function
        /// Set the sender to `SplitViewController`, aka `self`
        announcementVC.reload(self)
    }
    
    // Open filters
    @objc func filterPosts() {
        // Get announcementVC and open filter
        announcementVC.openFilter()
    }
    
    // Share post
    @objc func sharePost() {
        // Get contentVC and call the sharePost @IBAction function
        /// Set the sender to `SplitViewController`, aka `self`
        contentVC.sharePost(self)
    }
    
    // Pin post
    @objc func pinPost() {
        // Get contentVC and call the pinPost @IBAction function
        /// Set the sender to `SplitViewController`, aka `self`
        contentVC.pinnedItem(self)
    }
    
    // Pin post
    @objc func openSafari() {
        // Get contentVC and call the safari @IBAction function
        /// Set the sender to `SplitViewController`, aka `self`
        contentVC.openPostInSafari(self)
    }
    
    // Reset zoom
    @objc func resetPostZoom() {
        // Creating attributed text
        let attr = NSMutableAttributedString(attributedString: contentVC.contentTextView.attributedText)
        
        // Setting currentScale
        contentVC.currentScale = GlobalIdentifier.defaultFontSize
        
        // New font size and style
        let font = UIFont.systemFont(ofSize: contentVC.currentScale, weight: .medium)
        
        // Setting text color using NSAttributedString
        attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: attr.length))
        
        // Setting attributedText on contentTextView
        contentVC.contentTextView.attributedText = attr
        
        // Updating UserDefaults with the new scale
        UserDefaults.standard.set(contentVC.currentScale, forKey: UserDefaultsIdentifiers.textScale.rawValue)
    }
    
    // Zoom in cmd = or cmd + is used
    @objc func zoomInPost() {
        // Creating attributed text
        let attr = NSMutableAttributedString(attributedString: contentVC.contentTextView.attributedText)
        
        // Setting currentScale
        // Limit is 50
        contentVC.currentScale = {
            (round(contentVC.currentScale / 5) + 1) * 5
        }()
        
        // New font size and style
        let font = UIFont.systemFont(ofSize: contentVC.currentScale, weight: .medium)
        
        // Setting text color using NSAttributedString
        attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: attr.length))
        
        // Setting attributedText on contentTextView
        contentVC.contentTextView.attributedText = attr
        
        // Updating UserDefaults with the new scale
        UserDefaults.standard.set(contentVC.currentScale, forKey: UserDefaultsIdentifiers.textScale.rawValue)
    }
    
    // Zoom out cmd - is used
    @objc func zoomOutPost() {
        // Creating attributed text
        let attr = NSMutableAttributedString(attributedString: contentVC.contentTextView.attributedText)
        
        // Setting currentScale
        // Limit is 50
        contentVC.currentScale = {
            (round(contentVC.currentScale / 5) - 1) * 5
        }()
        
        // New font size and style
        let font = UIFont.systemFont(ofSize: contentVC.currentScale, weight: .medium)
        
        // Setting text color using NSAttributedString
        attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: attr.length))
        
        // Setting attributedText on contentTextView
        contentVC.contentTextView.attributedText = attr
        
        // Updating UserDefaults with the new scale
        UserDefaults.standard.set(contentVC.currentScale, forKey: UserDefaultsIdentifiers.textScale.rawValue)
    }
    
    /// Open next post
    @objc func nextPost() {
        var path = announcementVC.selectedPath
        
        // Get items in each section
        let itemsInSegment = announcementVC.announcementTableView.numberOfRows(inSection: path.section)
        
        // Get number of sections
        let numberOfSegments = announcementVC.announcementTableView.numberOfSections
        
        if path.row > itemsInSegment - 2 && path.section == numberOfSegments - 1 { return }
        
        if path.row < itemsInSegment - 1 {
            path.row += 1
            
        } else if numberOfSegments > 1 {
            path = IndexPath(row: 0, section: 1)
            
        }
        
        // Update tableView
        announcementVC.tableView(announcementVC.announcementTableView,
                                             didSelectRowAt: path)
        
        // Scroll to the row
        announcementVC.announcementTableView.scrollToRow(at: {
            // Create a newPath that will push out the row before
            // If it is the first row, just use the first row
            // This fixes the crash bug when the TableView is scrolling
            
            var newPath = path
            
            let itemsInNewSegment = announcementVC.announcementTableView.numberOfRows(inSection: newPath.section)
            
            if newPath.row != itemsInNewSegment - 1 {
                newPath.row += 1
            } else if newPath.section == 0 && newPath.row == itemsInNewSegment - 1 {
                newPath = IndexPath(row: 0, section: 1)
            }
            
            return newPath
        }(),
                                                                     at: .bottom,
                                                                     animated: true)
    }
    
    /// Open previous post
    @objc func previousPost() {
        var path = announcementVC.selectedPath
        
        // Handling if it is the first IndexPath
        if path == IndexPath(row: 0, section: 0) { return }
        
        if path.row == 0 {
            // Handling first row but not the first section
            let numberOfRows = announcementVC.announcementTableView.numberOfRows(inSection: 0)
            
            path = IndexPath(row: numberOfRows - 1, section: 0)
            
        } else if path.row >= 1 {
            // Reducing the path number by 1 to go to previous row
            path.row -= 1
            
        }
        
        // Scroll to the cell, so it does not crash
        announcementVC.announcementTableView.scrollToRow(at: {
            // Create a newPath that will push out the row before
            // If it is the first row, just use the first row
            // This fixes the crash bug when the TableView is scrolling
            
            var newPath = path
            
            if path.row != 0 {
                // In this case, it is ok to subtract 1
                newPath.row -= 1
            } else if path.section == 1 {
                // In this case, change the section
                newPath.section -= 1
            }
            // Otherwise, do not do anything
            
            // Return the new path and scroll to the new path
            return newPath
        }(),
                                                                     at: .top,
                                                                     animated: true)
        
        // Update tableViewCell and content
        announcementVC.tableView(announcementVC.announcementTableView,
                                             didSelectRowAt: path)

    }
    
    /// Open Settings app and go to the SST Announcer tab
    @objc func openSettings() {
        // Getting settings URL from app
        let settings = UIApplication.openSettingsURLString
        
        // Open settings url (in the Settings app)
        UIApplication.shared.open(URL(string: settings)!)
    }
}
