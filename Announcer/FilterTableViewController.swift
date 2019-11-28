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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get Labels
        labels = fetchLabels().sorted()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! FilterTableViewCell
        
        cell.title = labels[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the tvc
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        
        // Pass the cell's title over to the next VC
        filter = cell.title
        print(selectedLabel)
        self.dismiss(animated: true) {
            // Thanks Eric (TT)
            // Run an onDismiss void which is defined in the AnnouncementVC file
            // This void tells the AnnouncementVC to filter based on the selected tag
            self.onDismiss!()
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
