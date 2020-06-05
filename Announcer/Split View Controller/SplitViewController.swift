//
//  SplitViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 4/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    let contentViewController = Storyboards.content.instantiateInitialViewController() as! ContentViewController
    var announcementViewController: AnnouncementsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setting announcerViewController
        let navigationController = children[0] as! UINavigationController
        announcementViewController = navigationController.visibleViewController as? AnnouncementsViewController
        
        // Show loading vc
        // Loading VC will be replaced by contentVC when the data has finished loading in AnnouncementVC
        show(LoadingViewController(), sender: nil)
        
        // Setting the display mode to be automatic
        self.preferredDisplayMode = .automatic
        
        // Set background style as sidebar
        self.primaryBackgroundStyle = .sidebar
    }
    
    override var keyCommands: [UIKeyCommand]? {
        let search = UIKeyCommand(title: "Search",
                                  image: UIImage(systemName: "magnifyingglass"),
                                  action: #selector(startSearching),
                                  input: "f",
                                  modifierFlags: .command,
                                  discoverabilityTitle: "Search",
                                  state: .mixed)
        
        let reload = UIKeyCommand(title: "Reload",
                                  image: UIImage(systemName: "arrow.clockwise"),
                                  action: #selector(reloadView),
                                  input: "r",
                                  modifierFlags: .command,
                                  discoverabilityTitle: "Reload",
                                  state: .mixed)
        
        let filter = UIKeyCommand(title: "Filter Posts",
                                  image: Assets.filter,
                                  action: #selector(filterPosts),
                                  input: "f",
                                  modifierFlags: [.command, .shift],
                                  discoverabilityTitle: "Filter Posts",
                                  state: .mixed)
        
        let share = UIKeyCommand(title: "Share",
                                  image: Assets.share,
                                  action: #selector(sharePost),
                                  input: "s",
                                  modifierFlags: .command,
                                  discoverabilityTitle: "Share Post",
                                  state: .mixed)
        
        let pin = UIKeyCommand(title: "Pin",
                               image: Assets.pin,
                               action: #selector(pinPost),
                               input: "p",
                               modifierFlags: .command,
                               discoverabilityTitle: "Pin Post",
                               state: .mixed)
        
        let safari = UIKeyCommand(title: "Open in Safari",
                                  image: Assets.safari,
                                  action: #selector(pinPost),
                                  input: "s",
                                  modifierFlags: [.command, .shift],
                                  discoverabilityTitle: "Open in Safari",
                                  state: .mixed)
        
        let settings = UIKeyCommand(title: "Settings",
                                  image: Assets.settings,
                                  action: #selector(openSettings),
                                  input: ",",
                                  modifierFlags: [.command],
                                  discoverabilityTitle: "Settings",
                                  state: .mixed)
        
        let downArrow = UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(nextPost))
        let rightArrow = UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(nextPost))
        
        let upArrow = UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(previousPost))
        let leftArrow = UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(previousPost))

        
        return [settings, search, filter, reload,
                share, safari, pin,
                downArrow, upArrow, rightArrow, leftArrow]
    }

    @objc func startSearching() {
        announcementViewController.searchField.becomeFirstResponder()
    }
    
    @objc func reloadView() {
        announcementViewController.reload(self)
    }
    
    @objc func filterPosts() {
        announcementViewController.openFilter()
    }
    
    @objc func sharePost() {
        contentViewController.sharePost(self)
    }
    
    @objc func pinPost() {
        contentViewController.pinnedItem(self)
    }
    
    @objc func nextPost() {
        var path = announcementViewController.selectedPath
        
        // Get items in each section
        let itemsInSegment = announcementViewController.announcementTableView.numberOfRows(inSection: path.section)
        
        // Get number of sections
        let numberOfSegments = announcementViewController.announcementTableView.numberOfSections
        
        if path.row > itemsInSegment - 2 && path.section == numberOfSegments - 1 { return }
        
        if path.row < itemsInSegment - 1 {
            path.row += 1
            
        } else if numberOfSegments > 1 {
            path = IndexPath(row: 0, section: 1)
            
        }
        
        // Update tableView
        announcementViewController.tableView(announcementViewController.announcementTableView,
                                             didSelectRowAt: path)
        
        // Scroll to the row
        announcementViewController.announcementTableView.scrollToRow(at: {
            // Create a newPath that will push out the row before
            // If it is the first row, just use the first row
            // This fixes the crash bug when the TableView is scrolling
            
            var newPath = path
            
            let itemsInNewSegment = announcementViewController.announcementTableView.numberOfRows(inSection: newPath.section)
            
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
    
    @objc func previousPost() {
        var path = announcementViewController.selectedPath
        
        // Handling if it is the first IndexPath
        if path == IndexPath(row: 0, section: 0) { return }
        
        if path.row == 0 {
            // Handling first row but not the first section
            let numberOfRows = announcementViewController.announcementTableView.numberOfRows(inSection: 0)
            
            path = IndexPath(row: numberOfRows - 1, section: 0)
            
        } else if path.row >= 1 {
            // Reducing the path number by 1 to go to previous row
            path.row -= 1
            
        }
        
        // Scroll to the cell, so it does not crash
        announcementViewController.announcementTableView.scrollToRow(at: {
            // Create a newPath that will push out the row before
            // If it is the first row, just use the first row
            // This fixes the crash bug when the TableView is scrolling
            
            var newPath = path
            
            if path.row != 0 {
                newPath.row -= 1
            } else if path.section == 1 {
                newPath.section -= 1
            }
            
            return newPath
        }(),
                                                                     at: .top,
                                                                     animated: true)
        
        // Update tableViewCell and content
        announcementViewController.tableView(announcementViewController.announcementTableView,
                                             didSelectRowAt: path)

    }
    
    @objc func openSettings() {
        let settings = UIApplication.openSettingsURLString
        
        UIApplication.shared.open(URL(string: settings)!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
