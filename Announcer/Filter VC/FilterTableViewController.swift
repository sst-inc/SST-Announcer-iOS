//
//  FilterTableViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 28/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    var labels = [String]()
    var onDismiss: (() -> Void)?
    var selectedLabel = String()
    
    // Show activity indicator while fetching the data
    let loadingIndicator = UIActivityIndicatorView()
    
    // Creating activity indicator to show when loading
    override func loadView() {
        super.loadView()
        
        // Set up activity indicator
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        // Programmetic Constraints
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Align to center x and y, width and height are 40
        view.addConstraints([NSLayoutConstraint(item: loadingIndicator,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .centerX,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: loadingIndicator,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .centerY,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: loadingIndicator,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 40),
                             NSLayoutConstraint(item: loadingIndicator,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 40)
        ])

        
        view.addSubview(loadingIndicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show network activity indicator to indicate loading
        // This is deprecated for all non-notch devices (e.g. iPhone SE)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Getting the Labels asyncronously
        DispatchQueue.main.async {
            // Get labels from the Posts
            self.labels = Fetch.labels().sorted()
            
            // Hide loading indicator once done
            self.loadingIndicator.stopAnimating()
            
            // Stop the network activity indicator in status bar
            // This is deprecated for all non-notch devices (e.g. iPhone SE)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            // Reloading tableView with new data
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Creating a whole bunch of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GlobalIdentifier.labelCell, for: indexPath) as! FilterTableViewCell
        
        // Setting the title
        cell.title = labels[indexPath.row]
        
        // Creating preview interaction
        let interaction = UIContextMenuInteraction(delegate: self)
        
        // Adding interaction to cell
        cell.addInteraction(interaction)
        
        return cell
    }
    
    // Selected a label
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the tvc
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        
        // Pass the cell's title over to the next VC
        filter = cell.title
        
        self.dismiss(animated: true) {
            // Run an onDismiss void which is defined in the AnnouncementVC file
            // This void tells the AnnouncementVC to filter based on the selected label
            self.onDismiss!()
        }
    }
    
    // Close view controller when X pressed
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
}
