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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up activity indicator
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        loadingIndicator.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 10, y: UIScreen.main.bounds.height / 2 - 10, width: 20, height: 20)
        
        view.addSubview(loadingIndicator)
        
        // Getting the Labels asyncronously
        DispatchQueue.main.async {
            // Get labels from the Posts
            self.labels = Fetch.labels().sorted()
            
            // Hide loading indicator once
            self.loadingIndicator.stopAnimating()
            
            // Reloading tableView with new data
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GlobalIdentifier.labelCell, for: indexPath) as! FilterTableViewCell
        
        cell.title = labels[indexPath.row]
        
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
