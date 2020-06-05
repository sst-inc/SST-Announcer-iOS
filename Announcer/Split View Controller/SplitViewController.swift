//
//  SplitViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 4/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    let vc = Storyboards.content.instantiateInitialViewController() as! ContentViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Show loading vc
        // Loading VC will be replaced by contentVC when the data has finished loading in AnnouncementVC
        show(LoadingViewController(), sender: nil)
        
        // Setting the display mode to be automatic
        self.preferredDisplayMode = .automatic
        
        // Set background style as sidebar
        self.primaryBackgroundStyle = .sidebar
    }
    
    override var keyCommands: [UIKeyCommand]? {
        let search = UIKeyCommand.init(title: "Search", image: UIImage(systemName: "magnifyingglass"), action: #selector(startSearching), input: "f", modifierFlags: .command, discoverabilityTitle: "Search", state: .mixed)
        let reload = UIKeyCommand.init(title: "Reload", image: UIImage(systemName: "arrow.clockwise"), action: #selector(reloadView), input: "r", modifierFlags: .command, discoverabilityTitle: "Reload", state: .mixed)
        let filter = UIKeyCommand.init(title: "Filter Posts", image: UIImage(systemName: "three.line.horizontal.3.decrease.circle.fill"), action: #selector(filterPosts), input: "f", modifierFlags: [.command, .shift], discoverabilityTitle: "Filter Posts", state: .mixed)
        
        return [search, filter, reload]
    }

    @objc func startSearching() {
        let avc = (self.children[0] as! UINavigationController).children.first as! AnnouncementsViewController
        
        avc.searchField.becomeFirstResponder()
    }
    
    @objc func reloadView() {
        let avc = (self.children[0] as! UINavigationController).children.first as! AnnouncementsViewController
        
        avc.reload(self)
    }
    
    @objc func filterPosts() {
        let avc = (self.children[0] as! UINavigationController).children.first as! AnnouncementsViewController
        
        avc.openFilter()
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
